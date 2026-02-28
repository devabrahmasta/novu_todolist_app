import 'package:flutter/material.dart';

/// Novu brand color palette.
/// Dark-first, modern minimal, Gen-Z aesthetic.
class AppColors {
  AppColors._();

  // ─── Core ──────────────────────────────────────────────
  static const primary = Color(0xFF8C7DFF);
  static const primaryLight = Color(0xFFA89BFF);
  static const primaryDark = Color(0xFF6B5CE7);
  static const secondary = Color(0xFFCFFF5E); // lime — streak, done
  static const secondaryDark = Color(0xFFB8E844);
  static const tertiary = Color(0xFFB87EED); // soft purple — evening

  // ─── Backgrounds ──────────────────────────────────────
  static const bg = Color(0xFF0A0A12);
  static const bgElevated = Color(0xFF10101E);
  static const surface = Color(0xFF16162A);
  static const surface2 = Color(0xFF1E1E35);
  static const border = Color(0xFF2A2A45);

  // ─── Text ─────────────────────────────────────────────
  static const textPrimary = Color(0xFFF0EEFF);
  static const textSecondary = Color(0xFF9490B5);
  static const textMuted = Color(0xFF4A4870);

  // ─── Semantic ─────────────────────────────────────────
  static const success = Color(0xFFCFFF5E);
  static const error = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFFD166);

  // ─── Time of Day ──────────────────────────────────────
  static const morning = Color(0xFFFFD166);
  static const afternoon = Color(0xFFFF9A3C);
  static const evening = Color(0xFFB87EED);

  // ─── Priority (always optional on task) ───────────────
  static const priorityHigh = Color(0xFFFF6B6B);
  static const priorityMedium = Color(0xFFFFD166);
  static const priorityLow = Color(0xFF34D399);

  // ─── Light theme overrides ────────────────────────────
  static const lightBg = Color(0xFFF8F7FF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFF0EEFF);
  static const lightBorder = Color(0xFFE0DCF5);
  static const lightTextPrimary = Color(0xFF1A1830);
  static const lightTextSecondary = Color(0xFF6B6590);
  static const lightTextMuted = Color(0xFFA09CC0);
}
