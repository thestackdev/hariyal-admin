import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'package:superuser/main.dart';
import 'package:superuser/utils.dart';

class SubCategories extends StatefulWidget {
  final mapKey;

  const SubCategories({Key key, this.mapKey}) : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  final textController = TextEditingController();
  List items = [];
  DocumentSnapshot snapshot;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    final utils = context.watch<Utils>();
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == 'category') {
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
            onPressed: () {
              textController.clear();
              utils.getSimpleDialouge(
                title: 'Add Sub-Category',
                content: utils.dialogInput(
                  hintText: 'Type here',
                  controller: textController,
                ),
                noPressed: () => Get.back(),
                yesPressed: () => addSubCategory(),
              );
            }),
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
                  content: Text('Delete this Sub-Category ?'),
                  yesPressed: () {
                    deleteSubCategory(items[index]);

                    snapshot.reference.updateData({
                      widget.mapKey: FieldValue.arrayRemove([items[index]])
                    });
                    Get.back();
                  },
                  noPressed: () => Get.back(),
                );
              } else {
                textController.text = items[index];
                return await utils.getSimpleDialouge(
                  title: 'Edit Sub-Category',
                  content: utils.dialogInput(
                    hintText: 'Type here',
                    controller: textController,
                  ),
                  noPressed: () => Get.back(),
                  yesPressed: () {
                    if (utils.validateInputText(textController.text) &&
                        textController.text != items[index] &&
                        !items.contains(textController.text.toLowerCase())) {
                      editSubCategory(items[index], textController.text);
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
              isTrailingNull: true,
            ),
          ),
        ),
      ),
    );
  }

  addSubCategory() {
    if (utils.validateInputText(textController.text) &&
        !items.contains(textController.text.toLowerCase())) {
      snapshot.reference.updateData({
        '${widget.mapKey}':
            FieldValue.arrayUnion([textController.text.toLowerCase()])
      });
      Get.back();
      utils.showSnackbar('Subcategory Added');
    } else {
      Get.back();
      utils.showSnackbar('Invalid entries');
    }

    textController.clear();
  }

  deleteSubCategory(String data) {
    firestore
        .collection('products')
        .where('category.subCategory', isEqualTo: data)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({
          'category.subCategory': null,
          'isDeleted': true,
        });
      });
    });
  }

  editSubCategory(String oldData, String newData) {
    firestore
        .collection('products')
        .where('category.subCategory', isEqualTo: oldData)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({'category.subCategory': newData});
      });
    });
  }

  handleState() => (mounted) ?? setState(() => null);
}
