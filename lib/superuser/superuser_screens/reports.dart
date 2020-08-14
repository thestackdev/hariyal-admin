import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Reports extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Reports',
      child: Center(
        child: Text('Work in Progress',
            style: Get.textTheme.headline4.apply(fontSizeFactor: 1.5)),
      ),
    );
  }
}
