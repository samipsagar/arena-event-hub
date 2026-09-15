import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sports/core/feedback/feedback_service.dart';
import 'package:sports/core/feedback/providers.dart';
import 'package:sports/features/event/domain/entity/event.dart';
import 'package:sports/features/event/domain/entity/event_form_data.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';
import 'package:sports/features/event/domain/entity/sport.dart';
import 'package:sports/features/event/presentation/detail/event_detail_view_model.dart';
import 'package:sports/features/event/presentation/form/event_form_state.dart';
import 'package:sports/features/event/presentation/form/event_form_view_model.dart';
import 'package:sports/features/event/presentation/list/events_view_model.dart';

class EventFormScreen extends ConsumerStatefulWidget {
  const EventFormScreen({super.key, this.event});

  final Event? event;

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  static final _startsAtFormat = DateFormat('EEE d MMM yyyy • HH:mm');

  final _formKey = GlobalKey<FormState>();

  bool get isUpdate => widget.event != null;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _durationController;
  late final TextEditingController _venueController;
  late final TextEditingController _participantLimitController;
  late final TextEditingController _registeredParticipantController;
  late Sport _selectedSport;
  late EventStatus _selectedEventStatus;

  /// Fixed at the status the event arrived with, not recomputed as the
  /// selection changes — otherwise picking one move drops the starting point
  /// off the list and there is no way back to it.
  late final List<EventStatus> _statusOptions;
  late DateTime _startsAt;

  @override
  void initState() {
    super.initState();

    final existing = widget.event;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _descriptionController = TextEditingController(
      text: existing?.description ?? '',
    );
    _venueController = TextEditingController(text: existing?.venue ?? '');
    _registeredParticipantController = TextEditingController(
      text: '${existing?.registeredParticipants ?? 0}',
    );
    _durationController = TextEditingController(
      text: '${existing?.durationInMinutes ?? 120}',
    );
    _participantLimitController = TextEditingController(
      text: '${existing?.participantLimit ?? 1000}',
    );
    _selectedSport = existing?.sport ?? Sport.football;
    _selectedEventStatus = existing?.status ?? EventStatus.scheduled;
    _statusOptions = _selectedEventStatus.withAllowedTransitions;
    _startsAt =
        existing?.startsAt ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _durationController.dispose();
    _participantLimitController.dispose();
    _registeredParticipantController.dispose();

    super.dispose();
  }

  Future<void> _pickStartsAt() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startsAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startsAt),
    );
    if (time == null) return;

    setState(() {
      _startsAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void onSubmit() {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) return;

    final oldEvent = widget.event;

    final formData = EventFormData(
      id: oldEvent?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      sport: _selectedSport,
      status: _selectedEventStatus,
      venue: _venueController.text.trim(),
      startsAt: _startsAt,
      durationInMinutes: int.parse(_durationController.text),
      participantLimit: int.parse(_participantLimitController.text),
      registeredParticipants: int.parse(_registeredParticipantController.text),
    );

    ref.read(eventFormViewModelProvider.notifier).save(formData);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<EventFormState>(eventFormViewModelProvider, (_, next) {
      switch (next) {
        case EventFormSuccess():
          final id = widget.event?.id;
          if (id != null) {
            ref.invalidate(eventDetailViewModelProvider(id));
          }
          ref.read(eventsViewModelProvider.notifier).refresh();
          if (context.mounted) context.pop();
        case EventFormFailure(:final error):
          ref.read(feedbackServiceProvider).showError(error.message);
        case EventFormIdle():
        case EventFormSubmitting():
          break;
      }
    });

    final isSubmitting =
        ref.watch(eventFormViewModelProvider) is EventFormSubmitting;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(title: Text(isUpdate ? 'Update Event' : 'Create Event')),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isUpdate ? 'Update' : 'Create'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 12,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                keyboardType: .name,
                validator: (value) =>
                    (value ?? '').trim().isEmpty ? 'Title is required.' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                keyboardType: .text,
              ),
              DropdownButtonFormField<Sport>(
                initialValue: _selectedSport,
                decoration: const InputDecoration(labelText: 'Sport'),
                items: [
                  for (final sport in Sport.values)
                    if (sport != Sport.all)
                      DropdownMenuItem(value: sport, child: Text(sport.label)),
                ],
                onChanged: (value) =>
                    setState(() => _selectedSport = value ?? _selectedSport),
                validator: (value) =>
                    value == null ? 'Sport is required.' : null,
              ),
              DropdownButtonFormField<EventStatus>(
                initialValue: _selectedEventStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  helperText: isUpdate
                      ? null
                      : 'New events always start as Scheduled.',
                ),
                items: [
                  for (final status in _statusOptions)
                    DropdownMenuItem(value: status, child: Text(status.label)),
                ],
                // Null disables the field: a new event cannot be given a
                // status, and a finished one has nowhere left to move to.
                onChanged: isUpdate && _statusOptions.length > 1
                    ? (value) => setState(
                        () => _selectedEventStatus =
                            value ?? _selectedEventStatus,
                      )
                    : null,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: const Text('Starts at'),
                subtitle: Text(_startsAtFormat.format(_startsAt)),
                onTap: _pickStartsAt,
              ),
              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(labelText: 'Venue'),
                validator: (value) =>
                    (value ?? '').trim().isEmpty ? 'Venue is required.' : null,
                keyboardType: .name,
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                ),
                keyboardType: .number,
                validator: (value) {
                  final duration = int.tryParse(value ?? '');
                  if (duration == null || duration <= 0) {
                    return 'Enter a duration greater than 0.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _participantLimitController,
                decoration: const InputDecoration(
                  labelText: 'Participant Limit',
                ),
                keyboardType: .number,
                validator: (value) {
                  final limit = int.tryParse(value ?? '');
                  if (limit == null || limit <= 0) {
                    return 'Enter a limit greater than 0.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _registeredParticipantController,
                decoration: const InputDecoration(
                  labelText: 'Registered Count',
                ),
                keyboardType: .number,
                validator: (value) {
                  final registered = int.tryParse(value ?? '');
                  final limit = int.tryParse(_participantLimitController.text);
                  if (registered == null || registered < 0) {
                    return 'Enter 0 or more.';
                  }
                  if (limit != null && registered > limit) {
                    return 'Cannot exceed the participant limit.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
