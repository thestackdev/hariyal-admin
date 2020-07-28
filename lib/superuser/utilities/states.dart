import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/superuser/utilities/areas.dart';
import 'package:superuser/utils.dart';

class States extends StatelessWidget {
  final Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    final utils = context.watch<Utils>();
    final CollectionReference products = firestore.collection('products');
    final CollectionReference showrooms = firestore.collection('showrooms');
    DocumentSnapshot snapshot;
    List items = [];
    String text = '';

    if (extras == null) {
      return utils.blankScreenLoading();
    }

    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == 'locations') {
        items.clear();
        snapshot = doc;
        items.addAll(doc.data.keys);
        break;
      }
    }

    addState() {
      if (utils.validateInputText(text) &&
          !items.contains(text.toLowerCase())) {
        snapshot.reference.updateData({text.toLowerCase(): []});
        Get.back();
        utils.showSnackbar('State Added');
      } else {
        Get.back();
        utils.showSnackbar('Invalid entries');
      }
      text = '';
    }

    deleteState(String data) {
      products
          .where('location.state', isEqualTo: data)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          element.reference.updateData({
            'location.state': null,
            'location.area': null,
            'isDeleted': true,
          });
        });
      });
      showrooms.where('state', isEqualTo: data).getDocuments().then((value) {
        value.documents.forEach((element) {
          element.reference.updateData({
            'state': null,
          });
        });
      });
    }

    editState(String oldData, String newData) {
      products
          .where('location.state', isEqualTo: oldData)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          element.reference.updateData({'location.state': newData});
        });
      });
      showrooms.where('state', isEqualTo: oldData).getDocuments().then((value) {
        value.documents.forEach((element) {
          element.reference.updateData({
            'state': newData,
          });
        });
      });
    }

    return Scaffold(
      appBar: utils.appbar('States', actions: [
        IconButton(
          icon: Icon(MdiIcons.plusOutline),
          onPressed: () => utils.getSimpleDialouge(
            title: 'Add State',
            content: utils.dialogInput(
                hintText: 'Type here',
                onChnaged: (value) {
                  text = value;
                }),
            noPressed: () => Get.back(),
            yesPressed: () => addState(),
          ),
        ),
      ]),
      body: utils.container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => utils.dismissible(
            key: UniqueKey(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                return await utils.getSimpleDialouge(
                  title: 'Confirm',
                  content: Text('Delete this State ?'),
                  yesPressed: () {
                    deleteState(items[index]);
                    snapshot.reference
                        .updateData({items[index]: FieldValue.delete()});
                    Get.back();
                  },
                  noPressed: () => Get.back(),
                );
              } else {
                return await utils.getSimpleDialouge(
                  title: 'Edit State',
                  content: utils.dialogInput(
                      hintText: 'Type here',
                      initialValue: items[index],
                      onChnaged: (value) {
                        text = value;
                      }),
                  noPressed: () => Get.back(),
                  yesPressed: () {
                    if (utils.validateInputText(text) &&
                        text != items[index] &&
                        !items.contains(text.toLowerCase())) {
                      List tempData = snapshot.data[items[index]];

                      snapshot.reference.updateData({text: tempData});
                      snapshot.reference
                          .updateData({items[index]: FieldValue.delete()});
                      editState(items[index], text);
                      Get.back();
                    } else {
                      Get.back();
                      utils.showSnackbar('Invalid entries');
                    }
                    text = '';
                  },
                );
              }
            },
            child: utils.listTile(
              title: items[index],
              onTap: () => Get.to(Areas(mapKey: items[index])),
            ),
          ),
        ),
      ),
    );
  }
}
