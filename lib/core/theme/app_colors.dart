import 'package:flutter/material.dart';

/// Novu color palette — Monochrome Minimalist.
/// Warm grayscale only. No color accents except error red.
class AppColors {
  AppColors._();

  // ══════════════════════════════════════════════════════
  // LIGHT THEME (PRIMARY)
  // ══════════════════════════════════════════════════════

  static const lightBg = Color(0xFFFAFAF9);
  static const lightBgElevated = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFF4F4F2);
  static const lightBorder = Color(0xFFE8E8E6);
  static const lightBorderStrong = Color(0xFFD0D0CC);

  static const lightTextPrimary = Color(0xFF1A1A18);
  static const lightTextSecondary = Color(0xFF6B6B68);
  static const lightTextMuted = Color(0xFFABABAB);

  static const lightAccent = Color(0xFF1A1A18); // same as text — monochrome
  static const lightSuccess = Color(0xFF1A1A18);

  // ══════════════════════════════════════════════════════
  // DARK THEME
  // ══════════════════════════════════════════════════════

  static const bg = Color(0xFF1A1A18);
  static const bgElevated = Color(0xFF212120);
  static const surface = Color(0xFF242422);
  static const surface2 = Color(0xFF2E2E2C);
  static const border = Color(0xFF3A3A38);
  static const borderStrong = Color(0xFF4A4A48);

  static const textPrimary = Color(0xFFFAFAF9);
  static const textSecondary = Color(0xFF9A9A96);
  static const textMuted = Color(0xFF5A5A58);

  static const darkAccent = Color(0xFFFAFAF9);
  static const darkSuccess = Color(0xFFFAFAF9);

  // ─── Error (only non-monochrome color) ─────────────
  static const error = Color(0xFFCC0000);
  static const errorDark = Color(0xFFFF4444);

  // ─── Priority (grayscale shades) ───────────────────
  static const priorityHigh = Color(0xFF1A1A18);
  static const priorityMedium = Color(0xFF6B6B68);
  static const priorityLow = Color(0xFFABABAB);

  // ─── Time of Day (grayscale variants) ──────────────
  static const morning = Color(0xFF8A8A88);
  static const afternoon = Color(0xFF6B6B68);
  static const evening = Color(0xFF4A4A48);

  // ─── Legacy aliases (avoid compile errors) ─────────
  static const accent = lightAccent;
  static const accentLight = lightAccent;
  static const accentSubtle = Color(0xFFF4F4F2);
  static const accentSubtleDark = Color(0xFF2E2E2C);
  static const success = lightSuccess;
  static const primary = lightAccent;
  static const primaryLight = lightAccent;
  static const primaryDark = lightAccent;
  static const secondary = lightSuccess;
  static const secondaryDark = lightSuccess;
  static const tertiary = evening;
  static const warning = Color(0xFF6B6B68);
  static const warningSubtle = Color(0xFFF4F4F2);
  static const successSubtle = Color(0xFFF4F4F2);
  static const errorSubtle = Color(0xFFF4F4F2);
}
