import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/get/pages.dart';

final theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.redAccent,
  primarySwatch: Colors.red,
  scaffoldBackgroundColor: Colors.redAccent,
  textTheme: TextTheme(
    ////////////Button Text Theme///////////
    headline1: GoogleFonts.aBeeZee(
      letterSpacing: 1,
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),

    //////////Input Text Style//////////
    headline2: GoogleFonts.aBeeZee(
      fontSize: 16,
      letterSpacing: 1,
      color: Colors.grey.shade700,
      fontWeight: FontWeight.normal,
    ),
    //////////Normal Text Style//////////
    headline3: GoogleFonts.aBeeZee(
      fontSize: 16,
      letterSpacing: 1,
      color: Colors.grey.shade700,
      fontWeight: FontWeight.normal,
    ),
    //////////Title Text Style//////////
    headline4: GoogleFonts.aBeeZee(
      fontSize: 16,
      letterSpacing: 1,
      color: Colors.grey.shade700,
      fontWeight: FontWeight.bold,
    ),
    //////////Title Text Style//////////
    headline5: GoogleFonts.aBeeZee(
      letterSpacing: 1,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 23,
    ),
    ///////////////////////////////////////
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide.none,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide.none,
    ),
    isDense: true,
    contentPadding: EdgeInsets.all(16),
    border: InputBorder.none,
    fillColor: Colors.grey.shade50,
    filled: true,
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    margin: EdgeInsets.all(9),
    elevation: 3,
    shadowColor: Colors.red.shade50,
  ),
  tabBarTheme: TabBarTheme(
      //TODO
      ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    shape: RoundedRectangleBorder(
      side: BorderSide.none,
      borderRadius: BorderRadius.circular(9),
    ),
    buttonColor: Colors.redAccent,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Future.delayed(Duration(seconds: 1), () {
    Get.put(Controllers());
  });

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(
    GetMaterialApp(
      defaultTransition: Transition.rightToLeftWithFade,
      enableLog: false,
      getPages: Pages.routes,
      theme: theme,
      debugShowCheckedModeBanner: false,
      initialRoute: 'initialPage',
    ),
  );
}
