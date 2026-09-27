import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  // Spacing values
  static const double xs = 5.0;
  static const double sm = 10.0;
  static const double md = 15.0;
  static const double lg = 25.0;
  static const double xl = 30.0;
  static const double xxl = 45.0;

  // Edge insets shortcuts
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
}

/// Border radius constants
class AppRadius {
  static const double sm = 5.0;
  static const double md = 10.0;
  static const double lg = 15.0;
  static const double xl = 20.0; // Não usado no design por enquanto.
}

// =============================================================================
// THEME EXTENSIONS
// =============================================================================

/// Extension para acessar facilmente as cores e propriedades do tema
extension ThemeContext on BuildContext {
  /// Acessa o ColorScheme atual (Material 3)
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Acessa o ThemeData completo
  ThemeData get theme => Theme.of(this);
}

/// Extension to add text style utilities to BuildContext
/// Access via context.textStyles
extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

/// Helper methods for common text style modifications
extension TextStyleExtensions on TextStyle {
  /// Make text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Make text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Make text medium weight
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Make text normal weight
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  /// Make text light
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  /// Add custom color
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Add custom size
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

class FontSizes {
  static const double displayLarge = 36.0;
  static const double displayMedium = 30.0;
  static const double headlineLarge = 28.0;
  static const double headlineMedium = 26.0;
  static const double titleLarge = 24.0;
  static const double titleMedium = 22.0;
  static const double labelLarge = 18.0;
  static const double labelMedium = 16.0;
  static const double labelSmall = 14.0;
  static const double bodyMedium = 12.0;
}

class LightModeColors {
  // Primary
  static const lightPrimary = Color(0xFFFFFCEE);
  static const lightOnPrimary = Color(0xFF2C0E2C);
  static const lightAccentOnPrimary = Color(0xFF552662);

  // Secondary
  static const lightSecondary = Color(0xFF3E184C);
  static const lightOnSecondary = Color(0xFFFFFCEE);
  static const lightAccentOnSecondary = Color(0xFFDBA7F0);

  // Tertiary
  static const lightTertiary = Color(0xFF53284F);
  static const lightOnTertiary = Color(0xFFFFFCEE);

  static const lightErrorContainer = Color(0xFFF9DEDC);
  static const lightOnErrorContainer = Color(0xFF410E0B);

  // Background & Surface
  static const lightHighlight = Color(0xAA8945A3);
  static const lightTextOnHighlight = Color(0xFF692782);

  // Error sem definir
  static const lightError = Color(0xFFB3261E);
  static const lightOnError = Color(0xFFFFFFFF);

  // Outline
  static const lightOutline = Color(0xFF857582);

  static const lightShadow = Color(0xFF000000);

  static const lightInversePrimary = Color(0xFFDDB9E7);
}

ThemeData get theme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    error: LightModeColors.lightError,
    onError: LightModeColors.lightOnError,
    errorContainer: LightModeColors.lightErrorContainer,
    onErrorContainer: LightModeColors.lightOnErrorContainer,
    outline: LightModeColors.lightOutline,
    shadow: LightModeColors.lightShadow,
    inversePrimary: LightModeColors.lightInversePrimary,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: LightModeColors.lightPrimary,
  // filledButtonTheme: FilledButtonThemeData(
  //   style: FilledButton.styleFrom(
  //     backgroundColor: LightModeColors.lightSecondary.withValues(alpha: 0.6),
  //     foregroundColor: LightModeColors.lightOnSecondary,
  //     textStyle: const TextStyle(fontWeight: FontWeight.w600),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(AppRadius.md),
  //     ),
  //   ),
  // ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: LightModeColors.lightTertiary,
      foregroundColor: LightModeColors.lightOnSecondary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: LightModeColors.lightSecondary,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: LightModeColors.lightOutline.withValues(alpha: 0.2),
        width: 1,
      ),
    ),
  ),
  textTheme: _buildTextTheme(Brightness.light),
);

//Build text theme using Inter font family
TextTheme _buildTextTheme(Brightness brightness) {
  return TextTheme(
    displayLarge: GoogleFonts.unna(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 1,
    ),
    displayMedium: GoogleFonts.unna(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.5,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: FontSizes.headlineLarge,
      //pode ter diferentes pesos
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.5,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.5,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: FontSizes.titleMedium,
      letterSpacing: -0.5,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.5,
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: FontSizes.labelMedium,
      // fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: 1,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
  );
}
