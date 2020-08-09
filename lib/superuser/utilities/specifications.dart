import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Specifications extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final DocumentSnapshot snapshot = controllers.categories.value;
      final List items = snapshot.data.keys.toList();

      return controllers.utils.root(
        label: 'Select Category',
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => controllers.utils.listTile(
            title: items[index],
            onTap: () =>
                Get.toNamed('/specifications_data', arguments: items[index]),
          ),
        ),
      );
    });
  }
}
