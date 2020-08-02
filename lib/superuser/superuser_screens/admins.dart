import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/utils.dart';
import 'package:intl/intl.dart';

class Admins extends StatelessWidget {
  final Utils utils = Utils();
  final admin = Controllers.to.admin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Admins', actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Map<dynamic, dynamic> map = {
              'query': admin,
              'searchField': 'name',
              'type': 'admin'
            };
            Get.toNamed('/search', arguments: map);
          },
        )
      ]),
      body: utils.container(
        child: utils.buildProducts(
          query: admin.orderBy('timestamp', descending: true),
          itemBuilder: (context, snapshot) {
            return utils.listTile(
              title: snapshot.data['name'],
              subtitle:
                  'Since ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(snapshot['since']))}',
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
