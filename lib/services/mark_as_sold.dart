import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class MarkAsSold extends StatefulWidget {
  @override
  _MarkAsSoldState createState() => _MarkAsSoldState();
}

class _MarkAsSoldState extends State<MarkAsSold> {
  final DocumentSnapshot snapshot = Get.arguments;
  final controller = TextEditingController();
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Mark As Sold',
      child: ListView(
        children: <Widget>[
          SizedBox(height: 18),
          controllers.utils.inputTextField(
            label: 'Sold Reason',
            controller: controller,
          ),
          SizedBox(height: 18),
          RaisedButton(
            child: Text(
              'Sold',
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () {
              if (controller.text.length > 0) {
                snapshot.reference.updateData({
                  'isSold': true,
                  'soldReason': controller.text,
                  'sold_timestamp': DateTime.now().microsecondsSinceEpoch,
                });
                Get.back();
              } else {
                controllers.utils.snackbar('Invalid Reason');
              }
            },
          ),
        ],
      ),
    );
  }
}
