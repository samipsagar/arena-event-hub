import 'package:flutter/material.dart';

/// Sits at the end of the list while the next page loads.
class LoadingMoreRow extends StatelessWidget {
  const LoadingMoreRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
