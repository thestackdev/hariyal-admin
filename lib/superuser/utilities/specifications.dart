import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'package:superuser/superuser/utilities/specificationData.dart';
import 'package:superuser/utils.dart';

class Specifications extends StatefulWidget {
  @override
  _SpecificationsState createState() => _SpecificationsState();
}

class _SpecificationsState extends State<Specifications> {
  List items = [];
  final textController = TextEditingController();
  Firestore firestore = Firestore.instance;
  DocumentSnapshot snapshot;
  Utils utils;

  @override
  Widget build(BuildContext context) {
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    utils = context.watch<Utils>();

    if (extras == null) {
      return utils.blankScreenLoading();
    }

    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == 'category') {
        items.clear();
        snapshot = doc;
        items.addAll(doc.data.keys);
        break;
      }
    }

    return Scaffold(
      appBar: utils.appbar(capitalize('Choose Category')),
      body: utils.container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => utils.listTile(
            title: capitalize(items[index]),
            onTap: () => Get.to(SpecificationData(), arguments: items[index]),
          ),
        ),
      ),
    );
  }
}
