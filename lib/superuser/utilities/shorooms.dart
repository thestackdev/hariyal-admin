import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';

class Showrooms extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    deleteShowroom(String docID) {
      controllers.showrooms
          .where('address', isEqualTo: docID)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          element.reference.updateData({'address': null, 'isDeleted': true});
        });
      });
    }

    Widget active() {
      return DataStreamBuilder<QuerySnapshot>(
        stream: controllers.showrooms
            .orderBy('timestamp', descending: true)
            .where('active', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return controllers.utils.dismissible(
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return await controllers.utils.getSimpleDialouge(
                      title: 'Confirm',
                      content: Text('Delete this Showroom ?'),
                      yesPressed: () {
                        deleteShowroom(snapshot.documents[index].documentID);
                        snapshot.documents[index].reference
                            .updateData({'active': false});
                        Get.back();
                      },
                      noPressed: () => Get.back(),
                    );
                  } else {
                    return await Get.toNamed(
                      '/add_showroom',
                      arguments: snapshot,
                    );
                  }
                },
                key: UniqueKey(),
                child: controllers.utils.listTile(
                  onTap: () => Get.toNamed(
                    'showroom_details',
                    arguments: snapshot.documents[index].data,
                  ),
                  title: snapshot.documents[index]['name'],
                  subtitle: 'Address : ' + snapshot.documents[index]['address'],
                ),
              );
            },
          );
        },
      );
    }

    Widget inActive() {
      return DataStreamBuilder<QuerySnapshot>(
        stream: controllers.showrooms
            .orderBy('timestamp', descending: true)
            .where('active', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return controllers.utils.listTile(
                onTap: () => Get.toNamed(
                  'showroom_details',
                  arguments: snapshot.documents[index].data,
                ),
                title: snapshot.documents[index]['name'],
                subtitle: 'Address : ' + snapshot.documents[index]['address'],
              );
            },
          );
        },
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: controllers.utils.appbar(
          'Showrooms',
          actions: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.plusOutline),
              onPressed: () => Get.toNamed('add_showroom'),
            ),
          ],
          bottom: controllers.utils.tabDecoration('Active', 'InActive'),
        ),
        body: controllers.utils.container(
          child: TabBarView(
            children: <Widget>[
              active(),
              inActive(),
            ],
          ),
        ),
      ),
    );
  }
}
