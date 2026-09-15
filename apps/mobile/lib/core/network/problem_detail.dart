/// An RFC 9457 problem+json body.
///
/// Mirrors the backend's problem document: `detail` is written for a person
/// to read, `errors` (when present) says which field failed and why. Hand
/// written rather than generated, for the same reason as [CursorPage] — this
/// is only ever parsed, never built, and `errors` alone comes in two
/// different shapes depending on which backend endpoint produced it: a map
/// of field name to message, or a list of `{detail, pointer}` objects (the
/// SmartBear problem-details convention).
class ProblemDetail {
  const ProblemDetail({this.detail, this.errors = const []});

  /// Parses a problem document, or returns null if [json] isn't one (an HTML
  /// error page from a proxy, an empty body, a non-Map body).
  static ProblemDetail? fromJson(Object? json) {
    if (json is! Map) return null;

    final detail = json['detail'];
    final trimmed = detail is String ? detail.trim() : null;

    return ProblemDetail(
      detail: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      errors: _parseErrors(json['errors']),
    );
  }

  /// Safe to show to a user as-is.
  final String? detail;

  /// Field-level messages, formatted as `"field: message"` (or just the
  /// message when there's no field name to attach). Empty when the body
  /// carried no `errors`, or `errors` wasn't a shape we recognise.
  final List<String> errors;

  static List<String> _parseErrors(Object? errors) {
    if (errors is Map) {
      return [
        for (final entry in errors.entries)
          if (entry.value is String) '${entry.key}: ${entry.value}',
      ];
    }

    if (errors is List) {
      return [
        for (final item in errors)
          ...switch (item) {
            String() => [item],
            Map() => _errorFromPointer(item),
            _ => const <String>[],
          },
      ];
    }

    return const [];
  }

  static List<String> _errorFromPointer(Map item) {
    final detail = item['detail'];
    if (detail is! String || detail.trim().isEmpty) return const [];

    final pointer = item['pointer'];
    if (pointer is String && pointer.isNotEmpty) {
      final field = pointer.split('/').where((s) => s.isNotEmpty).join('.');
      if (field.isNotEmpty) return ['$field: $detail'];
    }

    return [detail];
  }
}
