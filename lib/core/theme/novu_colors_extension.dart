import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
class NovuColors extends ThemeExtension<NovuColors> {
  const NovuColors({
    required this.bg,
    required this.bgElevated,
    required this.surface,
    required this.surface2,
    required this.border,
    required this.borderStrong,
    required this.accentSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
  });

  final Color bg;
  final Color bgElevated;
  final Color surface;
  final Color surface2;
  final Color border;
  final Color borderStrong;
  final Color accentSubtle; // monochrome subtle background for chips/tags
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  static const light = NovuColors(
    bg: AppColors.lightBg,
    bgElevated: AppColors.lightBgElevated,
    surface: AppColors.lightSurface,
    surface2: AppColors.lightSurface2,
    border: AppColors.lightBorder,
    borderStrong: AppColors.lightBorderStrong,
    accentSubtle: AppColors.lightSurface2, // warm off-white tint
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    textMuted: AppColors.lightTextMuted,
  );

  static const dark = NovuColors(
    bg: AppColors.bg,
    bgElevated: AppColors.bgElevated,
    surface: AppColors.surface,
    surface2: AppColors.surface2,
    border: AppColors.border,
    borderStrong: AppColors.borderStrong,
    accentSubtle: AppColors.surface2, // dark subtle tint
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
  );

  @override
  NovuColors copyWith({
    Color? bg,
    Color? bgElevated,
    Color? surface,
    Color? surface2,
    Color? border,
    Color? borderStrong,
    Color? accentSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
  }) => NovuColors(
    bg: bg ?? this.bg,
    bgElevated: bgElevated ?? this.bgElevated,
    surface: surface ?? this.surface,
    surface2: surface2 ?? this.surface2,
    border: border ?? this.border,
    borderStrong: borderStrong ?? this.borderStrong,
    accentSubtle: accentSubtle ?? this.accentSubtle,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted: textMuted ?? this.textMuted,
  );

  @override
  NovuColors lerp(NovuColors? other, double t) {
    if (other == null) return this;
    return NovuColors(
      bg: Color.lerp(bg, other.bg, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
    );
  }
}

extension NovuThemeX on BuildContext {
  NovuColors get novuColors =>
      Theme.of(this).extension<NovuColors>() ?? NovuColors.light;
}
