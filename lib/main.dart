import 'package:flutter/material.dart';
import 'package:superuser/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Ubuntu',
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }));

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthServices().handleAuth(),
      theme: appTheme,
    ),
  );
}
