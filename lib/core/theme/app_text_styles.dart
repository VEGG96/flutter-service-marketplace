import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle heading(BuildContext context) => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle body(BuildContext context) => TextStyle(
        fontSize: 14,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle caption(BuildContext context) => TextStyle(
        fontSize: 12,
        color: Theme.of(context).textTheme.bodySmall?.color,
      );
}
