import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.icon,
    required this.title,
    this.detail,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Scrollable so that pull-to-refresh still works with nothing to scroll.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: .min,
                children: [
                  Icon(icon, size: 48, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: .center,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (detail != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      detail!,
                      textAlign: .center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (action != null) ...[const SizedBox(height: 24), action!],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
