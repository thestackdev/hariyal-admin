import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:intl/intl.dart';

class ShowroomDetails extends StatelessWidget {
  final controllers = Controllers.to;
  final Map snapshot = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Showroom Details'),
      body: controllers.utils.container(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: <Widget>[
            SizedBox(height: 18),
            buildWidget('Name : ', snapshot['name']),
            SizedBox(height: 18),
            buildWidget('Address : ', snapshot['address']),
            SizedBox(height: 18),
            buildWidget('Latitute : ', snapshot['latitude']),
            SizedBox(height: 18),
            buildWidget('Longitude : ', snapshot['longitude']),
            SizedBox(height: 18),
            buildWidget('State : ', snapshot['state']),
            SizedBox(height: 18),
            buildWidget('Area : ', snapshot['area']),
            SizedBox(height: 18),
            buildWidget(
              'Created At : ',
              DateFormat.yMMMd().format(
                  DateTime.fromMillisecondsSinceEpoch(snapshot['timestamp'])),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWidget(String key, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          key,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
