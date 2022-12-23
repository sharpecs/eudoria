import 'package:flutter/material.dart';
import 'package:eudoria/src/app_controller.dart';

/// An abstract interface for creating parts of an application indepedent of
/// the assembly process.
abstract class AppBuilder {}

/// AppBuilder responsible for defining the Application Styling and Theme.
class AppStyler extends AppBuilder {
  static TextStyle headerStyle(BuildContext context) {
    return TextStyle(
      color: Colors.blueGrey.shade100,
      fontSize: 14,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400,
      letterSpacing: 3,
    );
  }

  static Text appTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.appTitle,
      style: TextStyle(
        color: Colors.blueGrey.shade100,
        fontSize: 20,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w400,
        letterSpacing: 3,
      ),
    );
  }

  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.lightGreen,
      primaryColor: Colors.white,
      // backgroundColor: Colors.grey.shade200,
      indicatorColor: const Color(0xffCBDCF8),
      hintColor: const Color(0xff4285F4),
      highlightColor: const Color(0xffFCE192),
      hoverColor: const Color(0xff4285F4),
      focusColor: const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: Colors.white,
      canvasColor: Colors.grey[300],
      brightness: Brightness.light,
      buttonTheme: Theme.of(context)
          .buttonTheme
          .copyWith(colorScheme: const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}

/// A Layout Builder for supporting a responsive UI.
///
/// Centralises the use of [MediaQuery].
class AppFlexer extends AppBuilder {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width <= 1200;
  }

  // static Widget FlexLayout(BuildContext context) {
  //   final Widget largeScreen;
  //   final Widget? mediumScreen;
  //   final Widget? smallScreen;

  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       if (constraints.maxWidth > 1200) {
  //         return largeScreen;
  //       } else if (constraints.maxWidth <= 1200 &&
  //           constraints.maxWidth >= 800) {
  //         return mediumScreen ?? largeScreen;
  //       } else {
  //         return smallScreen ?? largeScreen;
  //       }
  //     },
  //   );
  // }
}

class Insets extends AppBuilder {
  static double medium = 5;
  static double large = 10;
  static double extraLarge = 20;
  static double small = 3;
}
