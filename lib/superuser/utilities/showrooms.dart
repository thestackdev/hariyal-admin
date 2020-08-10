import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
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

    Widget active() => controllers.utils.streamBuilder<QuerySnapshot>(
          stream: controllers.showrooms
              .orderBy('timestamp', descending: true)
              .where('active', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) => (snapshot.documents.length == 0)
              ? controllers.utils.error('No Showrooms found')
              : ListView.builder(
                  itemCount: snapshot.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return controllers.utils.dismissible(
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          return await controllers.utils
                              .getSimpleDialougeForNoContent(
                            title: 'Delete this Showroom ?',
                            yesPressed: () {
                              deleteShowroom(
                                  snapshot.documents[index].documentID);
                              snapshot.documents[index].reference
                                  .updateData({'active': false});
                              Get.back();
                            },
                            noPressed: () => Get.back(),
                          );
                        } else {
                          await Get.toNamed('add_showroom',
                              arguments: snapshot.documents[index]);
                          return false;
                        }
                      },
                      key: UniqueKey(),
                      child: controllers.utils.listTile(
                        onTap: () => Get.toNamed(
                          'showroom_details',
                          arguments: snapshot.documents[index].data,
                        ),
                        title: snapshot.documents[index]['name'],
                      ),
                    );
                  }),
        );

    Widget inActive() => controllers.utils.streamBuilder(
          stream: controllers.showrooms
              .orderBy('timestamp', descending: true)
              .where('active', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) => (snapshot.documents.length == 0)
              ? controllers.utils.error('No Showrooms found')
              : ListView.builder(
                  itemCount: snapshot.documents.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.grey.shade50,
                    ),
                    child: ListTile(
                      onTap: () => Get.toNamed(
                        'showroom_details',
                        arguments: snapshot.documents[index].data,
                      ),
                      title: Text(
                        GetUtils.capitalizeFirst(
                            snapshot.documents[index]['name'].trim()),
                        style: TextStyle(color: Colors.red),
                        textScaleFactor: 1.2,
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          SizedBox(height: 18),
                          controllers.utils.raisedButton('Make Active', () {
                            snapshot.documents[index].reference
                                .updateData({'active': true});
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
        );

    return DefaultTabController(
      length: 2,
      child: controllers.utils.root(
        label: 'Showrooms',
        actions: <Widget>[
          IconButton(
            icon: Icon(OMIcons.add),
            onPressed: () => Get.toNamed('add_showroom'),
          ),
        ],
        bottom: TabBar(
          tabs: <Widget>[Tab(text: 'Active'), Tab(text: 'Inactive')],
        ),
        child: TabBarView(
          children: <Widget>[active(), inActive()],
        ),
      ),
    );
  }
}
