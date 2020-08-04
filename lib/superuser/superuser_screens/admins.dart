import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:superuser/get/controllers.dart';

class Admins extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Admins', actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Map<dynamic, dynamic> map = {
              'query': controllers.admin,
              'searchField': 'name',
              'type': 'admin'
            };
            Get.toNamed('/search', arguments: map);
          },
        )
      ]),
      body: controllers.utils.container(
        child: controllers.utils.buildProducts(
          query: controllers.admin.orderBy('timestamp', descending: true),
          itemBuilder: (index, context, snapshot) {
            return controllers.utils.listTile(
              title: snapshot.data['name'],
              subtitle:
                  'Since ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(snapshot['timestamp']))}',
              onTap: () => Get.toNamed(
                '/admin_extras',
                arguments: snapshot.documentID,
              ),
            );
          },
        ),
      ),
    );
  }
}
