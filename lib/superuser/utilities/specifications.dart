import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:superuser/superuser/utilities/specificationData.dart';
import 'package:superuser/utils.dart';

class Specifications extends StatelessWidget {
  final Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    final utils = context.watch<Utils>();
    List items = [];

    if (extras == null) {
      return utils.blankScreenLoading();
    }

    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == 'category') {
        items.clear();
        items.addAll(doc.data.keys);
        break;
      }
    }

    return Scaffold(
      appBar: utils.appbar('Choose Category'),
      body: utils.container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => utils.listTile(
            title: items[index],
            onTap: () => Get.to(SpecificationData(), arguments: items[index]),
          ),
        ),
      ),
    );
  }
}
