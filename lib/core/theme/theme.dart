import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_thesis_front_end/core/theme/app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 3),
    );
  }

  static get lightModeTheme => (BuildContext context) {
        return ThemeData.light().copyWith(
          scaffoldBackgroundColor: AppPallete.backgroundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: AppPallete.backgroundColor,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              height: 1.2,
              fontWeight: FontWeight.bold,
              color: AppPallete.textColor,
            ),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(fontFamily: GoogleFonts.poppins().fontFamily),
          chipTheme: ChipThemeData(
            color: WidgetStatePropertyAll(AppPallete.backgroundColor),
            side: BorderSide.none,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: _border(),
            contentPadding: const EdgeInsets.all(27),
            focusedBorder: _border(AppPallete.gradient3),
            enabledBorder: _border(),
            errorBorder: _border(AppPallete.errorColor),
          ),
        );
      };
}
