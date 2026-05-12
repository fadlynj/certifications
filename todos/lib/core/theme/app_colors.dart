// Material 3 colour palette — single source of truth.
import 'package:flutter/material.dart';

/// Brand colour tokens for light and dark themes.
class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6366F1); // Calm violet (indigo-500)
  static const Color primaryLight = Color(0xFFF5F3FF); // Violet-50 warm tint
  static const Color primaryDark = Color(0xFFA5B4FC); // Indigo-300 for dark

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981); // Emerald-500
  static const Color warning = Color(0xFFF59E0B); // Amber-400
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color info = Color(0xFF3B82F6); // Blue-500

  // ── Neutrals (light) — warm stone ─────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFF5F4F2); // Stone-100
  static const Color backgroundLight = Color(0xFFFAF9F8); // Stone-50
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE8E6E3); // Stone-200
  static const Color onSurfaceLight = Color(0xFF0C0A09); // Stone-950
  static const Color subtleLight = Color(0xFF78716C); // Stone-500

  // ── Neutrals (dark) — warm zinc ───────────────────────────────────────────
  static const Color surfaceDark = Color(0xFF18181B); // Zinc-900
  static const Color backgroundDark = Color(0xFF0C0C0D); // Near black, warm
  static const Color cardDark = Color(0xFF18181B); // Zinc-900
  static const Color borderDark = Color(0xFF27272A); // Zinc-800
  static const Color onSurfaceDark = Color(0xFFFAFAFA); // Zinc-50
  static const Color subtleDark = Color(0xFF71717A); // Zinc-500

  // ── Chart palette ─────────────────────────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF6366F1),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFF97316),
  ];
}
