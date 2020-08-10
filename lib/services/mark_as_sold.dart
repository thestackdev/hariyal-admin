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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Mark As Sold',
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Wrap(
          spacing: 18,
          runSpacing: 18,
          children: <Widget>[
            controllers.utils.inputTextField(
              label: 'Sold Reason',
              controller: controller,
            ),
            controllers.utils.raisedButton(
              'Sold',
              () {
                if (controller.text.length > 0) {
                  snapshot.reference.updateData({
                    'isSold': true,
                    'soldReason': controller.text.trim(),
                    'sold_timestamp': DateTime.now().microsecondsSinceEpoch,
                  });
                  Get.back();
                } else {
                  controllers.utils.snackbar('Invalid Reason');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
