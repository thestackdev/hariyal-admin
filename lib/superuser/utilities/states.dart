import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'package:superuser/superuser/utilities/areas.dart';
import 'package:superuser/utils.dart';

class States extends StatefulWidget {
  @override
  _StatesState createState() => _StatesState();
}

class _StatesState extends State<States> {
  List items = [];
  final textController = TextEditingController();
  Firestore firestore = Firestore.instance;
  DocumentSnapshot snapshot;
  Utils utils;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuerySnapshot extras = context.watch<QuerySnapshot>();

    utils = context.watch<Utils>();

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

    return Scaffold(
      appBar: utils.appbar(capitalize('States'), actions: [
        IconButton(
          icon: Icon(MdiIcons.plusOutline),
          onPressed: () => utils.getSimpleDialouge(
            title: 'Add State',
            content: utils.dialogInput(
              hintText: 'Type here',
              controller: textController,
            ),
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
                textController.text = items[index];
                return await utils.getSimpleDialouge(
                  title: 'Edit State',
                  content: utils.dialogInput(
                    hintText: 'Type here',
                    controller: textController,
                  ),
                  noPressed: () => Get.back(),
                  yesPressed: () {
                    if (utils.validateInputText(textController.text) &&
                        textController.text != items[index] &&
                        !items.contains(textController.text.toLowerCase())) {
                      List tempData = snapshot.data[items[index]];

                      snapshot.reference
                          .updateData({textController.text: tempData});
                      snapshot.reference
                          .updateData({items[index]: FieldValue.delete()});
                      editState(items[index], textController.text);
                      Get.back();
                    } else {
                      Get.back();
                      utils.showSnackbar('Invalid entries');
                    }
                    textController.clear();
                  },
                );
              }
            },
            child: utils.listTile(
              title: capitalize(items[index]),
              onTap: () => Get.to(Areas(mapKey: items[index])),
            ),
          ),
        ),
      ),
    );
  }

  addState() {
    if (utils.validateInputText(textController.text) &&
        !items.contains(textController.text.toLowerCase())) {
      snapshot.reference.updateData({textController.text.toLowerCase(): []});
      Get.back();
      utils.showSnackbar('State Added');
    } else {
      Get.back();
      utils.showSnackbar('Invalid entries');
    }

    textController.clear();
  }

  deleteState(String data) {
    firestore
        .collection('products')
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
    firestore
        .collection('showrooms')
        .where('state', isEqualTo: data)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({
          'state': null,
        });
      });
    });
  }

  editState(String oldData, String newData) {
    firestore
        .collection('products')
        .where('location.state', isEqualTo: oldData)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({'location.state': newData});
      });
    });
    firestore
        .collection('showrooms')
        .where('state', isEqualTo: oldData)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({
          'state': newData,
        });
      });
    });
  }
}
