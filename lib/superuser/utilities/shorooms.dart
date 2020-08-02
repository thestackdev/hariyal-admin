import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';

class Showrooms extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    deleteShowroom(String docID) {
      controllers.showrooms
          .where('adress', isEqualTo: docID)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          element.reference.updateData({'adress': null, 'isDeleted': true});
        });
      });
    }

    Widget active() {
      return controllers.utils.container(
        child: controllers.utils.buildProducts(
            query: controllers.showrooms
                .orderBy('timestamp', descending: true)
                .where('active', isEqualTo: true),
            itemBuilder: (context, snapshot) {
              return controllers.utils.dismissible(
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return await controllers.utils.getSimpleDialouge(
                      title: 'Confirm',
                      content: Text('Delete this Showroom ?'),
                      yesPressed: () {
                        deleteShowroom(snapshot.documentID);
                        snapshot.reference.updateData({'active': false});
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
                    arguments: snapshot.data,
                  ),
                  title: snapshot['name'],
                  subtitle: 'Address : ' + snapshot['address'],
                ),
              );
            }),
      );
    }

    Widget inActive() {
      return controllers.utils.container(
        child: controllers.utils.buildProducts(
          query: controllers.showrooms
              .orderBy('timestamp', descending: true)
              .where('active', isEqualTo: false),
          itemBuilder: (context, snapshot) {
            return controllers.utils.listTile(
              title: snapshot['name'],
              subtitle: 'Address : ' + snapshot['adress'],
            );
          },
        ),
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
        body: TabBarView(
          children: <Widget>[
            active(),
            inActive(),
          ],
        ),
      ),
    );
  }
}
