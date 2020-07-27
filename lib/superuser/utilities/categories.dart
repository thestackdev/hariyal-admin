import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'package:superuser/superuser/utilities/sub_categories.dart';
import 'package:superuser/utils.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List items = [];
  final textController = TextEditingController();
  Firestore firestore = Firestore.instance;
  DocumentSnapshot snapshot;
  Utils utils;

  @override
  Widget build(BuildContext context) {
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    utils = context.watch<Utils>();

    if (extras == null) {
      return utils.blankScreenLoading();
    }

    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == 'category') {
        items.clear();
        snapshot = doc;
        items.addAll(doc.data.keys);
        break;
      }
    }

    return Scaffold(
      appBar: utils.appbar(capitalize('Categories'), actions: [
        IconButton(
          icon: Icon(MdiIcons.plusOutline),
          onPressed: () => utils.getSimpleDialouge(
            title: 'Add Category',
            content: utils.dialogInput(
              hintText: 'Type here',
              controller: textController,
            ),
            noPressed: () => Get.back(),
            yesPressed: () => addCategory(),
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
                  content: Text('Delete this Showroom ?'),
                  yesPressed: () {
                    deleteCategory(items[index]);
                    snapshot.reference
                        .updateData({items[index]: FieldValue.delete()});
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
                      List tempData = snapshot.data[items[index]];

                      snapshot.reference
                          .updateData({textController.text: tempData});
                      snapshot.reference
                          .updateData({items[index]: FieldValue.delete()});

                      editCategory(items[index], textController.text);
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
              onTap: () => Get.to(
                SubCategories(mapKey: items[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  addCategory() {
    if (utils.validateInputText(textController.text) &&
        !items.contains(textController.text.toLowerCase())) {
      snapshot.reference.updateData({textController.text.toLowerCase(): []});
      Get.back();
      utils.showSnackbar('Category Added');
    } else {
      Get.back();
      utils.showSnackbar('Invalid entries');
    }

    textController.clear();
  }

  deleteCategory(String data) {
    firestore
        .collection('products')
        .where('category.category', isEqualTo: data)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({
          'category.category': null,
          'category.subCategory': null,
          'isDeleted': true,
        });
      });
    });
  }

  editCategory(String oldData, String newData) {
    firestore
        .collection('products')
        .where('category.category', isEqualTo: oldData)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({'category.category': newData});
      });
    });
  }
}
