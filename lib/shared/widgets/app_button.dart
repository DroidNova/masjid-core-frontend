import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);
    final effectiveOnPressed = isLoading ? null : onPressed;

    if (isOutlined) {
      return OutlinedButton(
        onPressed: effectiveOnPressed,
        child: child,
      );
    }

    return FilledButton(
      onPressed: effectiveOnPressed,
      child: child,
    );
  }
}
