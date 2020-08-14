import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Something went Wrong',
            style: Get.textTheme.headline4.apply(fontSizeFactor: 1.5),
          ),
        ),
      );
}
