// BuildContext extension helpers — theme, size, navigation shortcuts.
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  // ── Theme ─────────────────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ── Size ──────────────────────────────────────────────────────────────────
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeScreen => screenWidth >= 1200;

  // ── Brightness ────────────────────────────────────────────────────────────
  bool get isDarkMode =>
      MediaQuery.platformBrightnessOf(this) == Brightness.dark;

  // ── Padding ───────────────────────────────────────────────────────────────
  EdgeInsets get safeAreaPadding => MediaQuery.paddingOf(this);
}
