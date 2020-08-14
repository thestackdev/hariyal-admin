import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:superuser/get/controllers.dart';

class Admins extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Admins',
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Map<dynamic, dynamic> map = {
              'query': controllers.admin,
              'searchField': 'name',
              'type': 'admin'
            };
            Get.toNamed('search', arguments: map);
          },
        ),
      ],
      child: controllers.utils.paginator(
          query: controllers.admin.orderBy('timestamp', descending: true),
          itemBuilder: (index, context, snapshot) {
            try {
              return controllers.utils.listTile(
                title: snapshot.data['name'],
                subtitle:
                    'Since ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(snapshot['timestamp']))}',
                onTap: () => Get.toNamed(
                  'admin_extras',
                  arguments: snapshot.documentID,
                ),
              );
            } catch (e) {
              return controllers.utils.error('Oops.., Something went wrong');
            }
          }),
    );
  }
}
