import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/get/pages.dart';

final theme = ThemeData(
  fontFamily: 'Ubuntu',
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  primaryColor: Colors.redAccent,
  scaffoldBackgroundColor: Colors.redAccent,
  textTheme: TextTheme(
    headline6: TextStyle(
      letterSpacing: 1,
      color: Colors.grey.shade700,
      fontWeight: FontWeight.bold,
    ),
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
    labelStyle: TextStyle(color: Colors.red.shade700),
    contentPadding: EdgeInsets.all(16),
    border: InputBorder.none,
    fillColor: Colors.grey.shade50,
    filled: true,
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    shape: RoundedRectangleBorder(
      side: BorderSide.none,
      borderRadius: BorderRadius.circular(9),
    ),
    buttonColor: Colors.red.shade300,
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 23,
      ),
    ),
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
      initialRoute: '/initialPage',
    ),
  );
}
