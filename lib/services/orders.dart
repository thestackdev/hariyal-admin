import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Orders extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) => controllers.utils.root(
        label: 'Orders',
        child: Center(
          child: Text(
            'Work in progress',
            style: Get.textTheme.headline4.apply(fontSizeFactor: 1.5),
          ),
        ),
      );
}
