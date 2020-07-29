import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:superuser/get/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(
    GetMaterialApp(
      defaultTransition: Transition.rightToLeftWithFade,
      enableLog: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Ubuntu',
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/initialPage',
      getPages: Pages.routes,
    ),
  );
}
