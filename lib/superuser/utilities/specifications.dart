import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Specifications extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Select Category',
      child: controllers.utils.streamBuilder<DocumentSnapshot>(
        stream: controllers.categoryStream,
        builder: (context, snapshot) => ListView.builder(
          itemCount: snapshot.data.keys.length,
          itemBuilder: (context, index) => controllers.utils.listTile(
            title: snapshot.data.keys.elementAt(index),
            onTap: () => Get.toNamed('specifications_data',
                arguments: snapshot.data.keys.elementAt(index)),
          ),
        ),
      ),
    );
  }
}
