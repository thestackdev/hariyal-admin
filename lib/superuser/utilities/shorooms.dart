import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/superuser/utilities/add_showroom.dart';
import 'package:superuser/utils.dart';

class Showrooms extends StatelessWidget {
  final Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    final CollectionReference products = firestore.collection('products');
    final CollectionReference showrooms = firestore.collection('showrooms');

    deleteShowroom(String docID) {
      products.where('adress', isEqualTo: docID).getDocuments().then((value) {
        value.documents.forEach((element) {
          element.reference.updateData({'adress': null, 'isDeleted': true});
        });
      });
    }

    return Scaffold(
      appBar: utils.appbar(
        'Showrooms',
        actions: <Widget>[
          IconButton(
              icon: Icon(MdiIcons.plusOutline),
              onPressed: () async {
                final res = await Get.to(AddShowroom());
                if (res == true) {
                  utils.showSnackbar('Showroom Added');
                }
              }),
        ],
      ),
      body: utils.container(
        child: DataStreamBuilder<QuerySnapshot>(
          stream: showrooms.snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.documents.length,
              itemBuilder: (context, index) {
                return utils.dismissible(
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return await utils.getSimpleDialouge(
                        title: 'Confirm',
                        content: Text('Delete this Showroom ?'),
                        yesPressed: () {
                          deleteShowroom(snapshot.documents[index].documentID);
                          snapshot.documents[index].reference.delete();
                          Get.back();
                        },
                        noPressed: () => Get.back(),
                      );
                    } else {
                      return await Get.to(
                        AddShowroom(),
                        arguments: snapshot.documents[index],
                      );
                    }
                  },
                  key: UniqueKey(),
                  child: utils.listTile(
                    title: snapshot.documents[index]['name'],
                    subtitle:
                        'Address : ' + snapshot.documents[index]['adress'],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
