import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/utils.dart';

class MarkAsSold extends StatefulWidget {
  @override
  _MarkAsSoldState createState() => _MarkAsSoldState();
}

class _MarkAsSoldState extends State<MarkAsSold> {
  final DocumentSnapshot snapshot = Get.arguments;
  final controller = TextEditingController();
  final utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Mark as sold'),
      body: utils.container(
          child: ListView(
        children: <Widget>[
          SizedBox(height: 18),
          utils.inputTextField(
            label: 'Sold Reason',
            controller: controller,
          ),
          SizedBox(height: 18),
          utils.getRaisedButton(
            title: 'Sold',
            onPressed: () {
              if (controller.text.length > 0) {
                snapshot.reference.updateData({
                  'isSold': true,
                  'soldReason': controller.text,
                });
                Get.back();
              } else {
                utils.showSnackbar('Invalid Reason');
              }
            },
          )
        ],
      )),
    );
  }
}
