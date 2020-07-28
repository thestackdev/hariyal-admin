import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/utils.dart';

class SubCategories extends StatelessWidget {
  final String mapKey;
  const SubCategories({Key key, this.mapKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    final CollectionReference products =
        Firestore.instance.collection('products');
    String text = '';
    List items = [];
    DocumentSnapshot snapshot;

    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == 'category') {
        items.clear();
        snapshot = doc;
        if (doc.data[mapKey] != null) {
          items.addAll(doc.data[mapKey]);
        }
        break;
      }
    }

    addSubCategory() {
      if (utils.validateInputText(text) &&
          !items.contains(text.toLowerCase())) {
        snapshot.reference.updateData({
          mapKey: FieldValue.arrayUnion([text.toLowerCase()])
        });
        Get.back();
        utils.showSnackbar('Subcategory Added');
      } else {
        Get.back();
        utils.showSnackbar('Invalid entries');
      }
      text = '';
    }

    deleteSubCategory(String data) {
      products
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
      products
          .where('category.subCategory', isEqualTo: oldData)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          element.reference.updateData({'category.subCategory': newData});
        });
      });
    }

    return Scaffold(
      appBar: utils.appbar(mapKey, actions: [
        IconButton(
            icon: Icon(MdiIcons.plusOutline),
            onPressed: () {
              utils.getSimpleDialouge(
                title: 'Add Sub-Category',
                content: utils.dialogInput(
                  onChnaged: (value) {
                    text = value;
                  },
                  hintText: 'Type here',
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
                      mapKey: FieldValue.arrayRemove([items[index]])
                    });
                    Get.back();
                  },
                  noPressed: () => Get.back(),
                );
              } else {
                return await utils.getSimpleDialouge(
                  title: 'Edit Sub-Category',
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
                      editSubCategory(items[index], text);
                      snapshot.reference.updateData({
                        mapKey: FieldValue.arrayRemove([items[index]]),
                      });
                      snapshot.reference.updateData({
                        mapKey: FieldValue.arrayUnion([text]),
                      });

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
            child: utils.listTile(title: items[index], isTrailingNull: true),
          ),
        ),
      ),
    );
  }
}
