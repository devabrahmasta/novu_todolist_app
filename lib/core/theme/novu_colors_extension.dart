import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic color extension — adapts to light/dark theme automatically.
@immutable
class NovuColors extends ThemeExtension<NovuColors> {
  const NovuColors({
    required this.bg,
    required this.bgElevated,
    required this.surface,
    required this.surface2,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
  });

  final Color bg;
  final Color bgElevated;
  final Color surface;
  final Color surface2;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  static const dark = NovuColors(
    bg: AppColors.bg,
    bgElevated: AppColors.bgElevated,
    surface: AppColors.surface,
    surface2: AppColors.surface2,
    border: AppColors.border,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
  );

  static const light = NovuColors(
    bg: AppColors.lightBg,
    bgElevated: AppColors.lightSurface,
    surface: AppColors.lightSurface,
    surface2: AppColors.lightSurface2,
    border: AppColors.lightBorder,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    textMuted: AppColors.lightTextMuted,
  );

  @override
  NovuColors copyWith({
    Color? bg,
    Color? bgElevated,
    Color? surface,
    Color? surface2,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
  }) {
    return NovuColors(
      bg: bg ?? this.bg,
      bgElevated: bgElevated ?? this.bgElevated,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  @override
  NovuColors lerp(NovuColors? other, double t) {
    if (other == null) return this;
    return NovuColors(
      bg: Color.lerp(bg, other.bg, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
    );
  }
}

/// Convenience extension on BuildContext.
extension NovuThemeX on BuildContext {
  NovuColors get novuColors =>
      Theme.of(this).extension<NovuColors>() ?? NovuColors.dark;
}
