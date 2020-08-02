import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/get/pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Future.delayed(Duration(seconds: 2), () {
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
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Ubuntu',
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.red,
        appBarTheme: AppBarTheme(elevation: 0),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/initialPage',
    ),
  );
}
