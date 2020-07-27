import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'package:superuser/utils.dart';

class Areas extends StatefulWidget {
  final mapKey;

  const Areas({Key key, this.mapKey}) : super(key: key);

  @override
  _AreasState createState() => _AreasState();
}

class _AreasState extends State<Areas> {
  final textController = TextEditingController();
  List items = [];
  DocumentSnapshot snapshot;
  Firestore firestore = Firestore.instance;
  Utils utils;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    utils = context.watch<Utils>();
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == 'locations') {
        items.clear();
        snapshot = doc;
        if (doc.data[widget.mapKey] != null) {
          items.addAll(doc.data[widget.mapKey]);
        }
        handleState();
        break;
      }
    }

    return Scaffold(
      appBar: utils.appbar(capitalize(widget.mapKey), actions: [
        IconButton(
          icon: Icon(MdiIcons.plusOutline),
          onPressed: () => utils.getSimpleDialouge(
            title: 'Add Areas',
            content: utils.dialogInput(
              hintText: 'Type here',
              controller: textController,
            ),
            noPressed: () => Get.back(),
            yesPressed: () => addArea(),
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
                  content: Text('Delete this Area ?'),
                  yesPressed: () {
                    deleteArea(items[index]);
                    snapshot.reference.updateData({
                      widget.mapKey: FieldValue.arrayRemove([items[index]]),
                    });
                    Get.back();
                  },
                  noPressed: () => Get.back(),
                );
              } else {
                textController.text = items[index];
                return await utils.getSimpleDialouge(
                  title: 'Edit Area',
                  content: utils.dialogInput(
                    hintText: 'Type here',
                    controller: textController,
                  ),
                  noPressed: () => Get.back(),
                  yesPressed: () {
                    if (utils.validateInputText(textController.text) &&
                        textController.text != items[index] &&
                        !items.contains(textController.text.toLowerCase())) {
                      editArea(items[index], textController.text);
                      snapshot.reference.updateData({
                        widget.mapKey: FieldValue.arrayRemove([items[index]]),
                      });
                      snapshot.reference.updateData({
                        widget.mapKey:
                            FieldValue.arrayUnion([textController.text]),
                      });

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
              isTrailingNull: false,
            ),
          ),
        ),
      ),
    );
  }

  addArea() {
    if (utils.validateInputText(textController.text) &&
        !items.contains(textController.text.toLowerCase())) {
      snapshot.reference.updateData({
        '${widget.mapKey}':
            FieldValue.arrayUnion([textController.text.toLowerCase()])
      });
      Get.back();
      utils.showSnackbar('Area Added');
    } else {
      Get.back();
      utils.showSnackbar('Invalid entries');
    }

    textController.clear();
  }

  deleteArea(String data) {
    firestore
        .collection('products')
        .where('location.area', isEqualTo: data)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({
          'location.area': null,
          'isDeleted': true,
        });
      });
    });
    firestore
        .collection('showrooms')
        .where('area', isEqualTo: data)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({
          'area': null,
        });
      });
    });
  }

  editArea(String oldData, String newData) {
    firestore
        .collection('products')
        .where('location.area', isEqualTo: oldData)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({'location.area': newData});
      });
    });
    firestore
        .collection('showrooms')
        .where('area', isEqualTo: oldData)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({
          'area': newData,
        });
      });
    });
  }

  handleState() => (mounted) ?? setState(() => null);
}
