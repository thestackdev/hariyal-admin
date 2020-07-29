import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/superuser/utilities/specificationData.dart';
import 'package:superuser/utils.dart';

class Specifications extends StatelessWidget {
  final Firestore firestore = Firestore.instance;
  final Controllers controllers = Get.find();
  final Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    List items = controllers.categories.value.data.keys.toList();

    return Scaffold(
      appBar: utils.appbar('Choose Category'),
      body: utils.container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => utils.listTile(
            title: items[index],
            onTap: () => Get.to(
              SpecificationData(category: items[index]),
            ),
          ),
        ),
      ),
    );
  }
}
