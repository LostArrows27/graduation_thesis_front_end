import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_thesis_front_end/core/theme/app_pallete.dart';

/// old theme class
class AppThemeOld {
  static _border([Color color = const Color.fromRGBO(0, 0, 0, 0.2)]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color, width: 2),
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
              .apply(fontFamily: 'Poppins'),
          chipTheme: ChipThemeData(
            color: WidgetStatePropertyAll(AppPallete.backgroundColor),
            side: BorderSide.none,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: _border(),
            contentPadding: const EdgeInsets.all(27),
            // focusedBorder: _border(AppPallete.primaryColor),
            enabledBorder: _border(),
            errorBorder: _border(AppPallete.errorColor),
          ),
        );
      };
}
