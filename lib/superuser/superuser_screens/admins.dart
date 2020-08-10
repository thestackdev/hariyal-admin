import 'package:cloud_firestore/cloud_firestore.dart';
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
      child: controllers.utils.streamBuilder<QuerySnapshot>(
        stream: controllers.admin
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) => (snapshot.documents.length == 0)
            ? controllers.utils.error('No Admins Found')
            : ListView.builder(itemBuilder: (context, index) {
                try {
                  return controllers.utils.listTile(
                    title: snapshot.documents[index].data['name'],
                    subtitle:
                        'Since ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(snapshot.documents[index]['timestamp']))}',
                    onTap: () => Get.toNamed(
                      'admin_extras',
                      arguments: snapshot.documents[index].documentID,
                    ),
                  );
                } catch (e) {
                  return controllers.utils
                      .error('Oops.., Something went wrong');
                }
              }),
      ),
    );
  }
}
