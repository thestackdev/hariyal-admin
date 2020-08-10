import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:intl/intl.dart';

class ShowroomDetails extends StatelessWidget {
  final controllers = Controllers.to;
  final Map snapshot = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Showroom Details',
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Wrap(
          spacing: 18,
          runSpacing: 18,
          children: <Widget>[
            buildWidget('Name : ', snapshot['name']),
            buildWidget('Address : ', snapshot['address']),
            buildWidget('Latitute : ', snapshot['latitude']),
            buildWidget('Longitude : ', snapshot['longitude']),
            buildWidget('State : ', snapshot['state']),
            buildWidget('Area : ', snapshot['area']),
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
        Text(key,
            style: Get.textTheme.headline3
                .apply(fontSizeFactor: 1.2, color: Colors.redAccent)),
        Flexible(
          child: Text(
            GetUtils.capitalizeFirst(value),
            style: Get.textTheme.headline3,
          ),
        ),
      ],
    );
  }
}
