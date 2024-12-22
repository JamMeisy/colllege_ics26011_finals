// theme_constants.dart

import 'package:flutter/material.dart';

class CustomTheme {
  // Main Colors
  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color darkYellow = Color(0xFFFFC000);
  static const Color accentBlack = Color(0xFF1A1A1A);
  static const Color lightYellow = Color(0xFFFFF8DC);

  // Status Colors
  static const Color pendingColor = Color(0xFFFFB900);
  static const Color approvedColor = Color(0xFF32CD32);
  static const Color rejectedColor = Color(0xFFDC143C);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: accentBlack,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: accentBlack,
  );

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryYellow,
    foregroundColor: accentBlack,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // Input Decoration
  static InputDecoration getInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentBlack),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentBlack.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryYellow, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: accentBlack.withOpacity(0.1)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  // App Bar Theme
  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: accentBlack,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: primaryYellow),
    titleTextStyle: TextStyle(
      color: primaryYellow,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );

  // Drawer Theme
  static DrawerThemeData drawerTheme = DrawerThemeData(
    backgroundColor: Colors.white,
    scrimColor: Colors.black.withOpacity(0.6),
  );

  // Status Badge Style
  static Widget getStatusBadge(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = pendingColor;
        break;
      case 'approved':
        backgroundColor = approvedColor;
        break;
      case 'rejected':
        backgroundColor = rejectedColor;
        break;
      default:
        backgroundColor = accentBlack;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AppTheme {
  static const Color primary = Color(0xFFFFD700);      // Bright yellow
  static const Color secondary = Color(0xFF000000);    // Black
  static const Color accent = Color(0xFFFFC107);       // Amber
  static const Color background = Color(0xFFFFFDF4);   // Light cream
  static const Color surface = Color(0xFFFFFFFF);      // White
  static const Color error = Color(0xFFD32F2F);        // Error red
  static const Color textPrimary = Color(0xFF000000);  // Black text
  static const Color textSecondary = Color(0xFF666666);// Gray text

  static ThemeData get theme => ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: background,
      surface: surface,
      error: error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: secondary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: secondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: primary,
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: error),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: textSecondary),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primary, width: 1),
      ),
      color: surface,
    ),
  );

  static Widget loadingIndicator({Color? color}) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color ?? primary),
      strokeWidth: 3,
    );
  }

  static InputDecoration searchDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText ?? 'Search',
      prefixIcon: Icon(Icons.search, color: secondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: surface,
    );
  }
}

// Custom button widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;
  final bool outlined;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppTheme.secondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: _buttonChild(),
      );
    }

    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: _buttonChild(),
    );
  }

  Widget _buttonChild() {
    return loading
        ? SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          outlined ? AppTheme.secondary : AppTheme.primary,
        ),
      ),
    )
        : Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}