import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Novu text style system.
///
/// - ClimateCrisis: display headings only (≥18px).
/// - Inter: body, headings, labels.
/// - SpaceMono: monospace for times, dates, hex values.
class AppTextStyles {
  AppTextStyles._();

  // ─── Display (ClimateCrisis) ──────────────────────────
  static TextStyle get displayLarge => GoogleFonts.climateCrisis(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.climateCrisis(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  // ─── Headings (Inter) ────────────────────────────────
  static TextStyle get headingLarge => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get headingMedium => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ─── Body (Inter) ────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ─── Label (Inter) ───────────────────────────────────
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.08 * 11, // 0.08em
    color: AppColors.textMuted,
  );

  // ─── Mono (SpaceMono) ────────────────────────────────
  static TextStyle get monoSmall => GoogleFonts.spaceMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
