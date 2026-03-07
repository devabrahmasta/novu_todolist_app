import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Novu typography — Monochrome Minimalist.
///
/// Font: DM Sans only. Weights: w400 (regular), w500 (medium), w600 (semibold).
/// No ClimateCrisis, no SpaceMono.
class AppTextStyles {
  AppTextStyles._();

  // ─── Display ─────────────────────────────────────────
  // Used for large numbers (streak count, stat cards)
  static TextStyle get displayLarge => GoogleFonts.dmSans(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.lightTextPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.dmSans(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.lightTextPrimary,
  );

  // ─── Headings ────────────────────────────────────────
  static TextStyle get headingLarge => GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.lightTextPrimary,
  );

  static TextStyle get headingMedium => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    color: AppColors.lightTextPrimary,
  );

  // ─── Body ────────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextSecondary,
  );

  // ─── Label ───────────────────────────────────────────
  static TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: AppColors.lightTextMuted,
  );

  // ─── Mono (DM Sans, tabular figures for numbers) ────
  static TextStyle get monoSmall => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextSecondary,
  );
}
