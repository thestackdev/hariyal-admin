import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';

class SubCategories extends StatelessWidget {
  final controllers = Controllers.to;
  final String mapKey = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final DocumentSnapshot snapshot = controllers.categories.value;
      final List items = snapshot[mapKey];
      String text = '';

      addSubCategory() {
        if (controllers.utils.validateInputText(text) &&
            !items.contains(text.toLowerCase())) {
          snapshot.reference.updateData({
            mapKey: FieldValue.arrayUnion([text.toLowerCase()])
          });
          Get.back();
          controllers.utils.showSnackbar('Subcategory Added');
        } else {
          Get.back();
          controllers.utils.showSnackbar('Invalid entries');
        }
        text = '';
      }

      deleteSubCategory(String data) {
        controllers.products
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
        controllers.products
            .where('category.subCategory', isEqualTo: oldData)
            .getDocuments()
            .then((value) {
          value.documents.forEach((element) {
            element.reference.updateData({'category.subCategory': newData});
          });
        });
      }

      return Scaffold(
        appBar: controllers.utils.appbar(mapKey, actions: [
          IconButton(
              icon: Icon(MdiIcons.plusOutline),
              onPressed: () {
                controllers.utils.getSimpleDialouge(
                  title: 'Add Sub-Category',
                  content: controllers.utils.dialogInput(
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
        body: controllers.utils.container(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => controllers.utils.dismissible(
              key: UniqueKey(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  return await controllers.utils.getSimpleDialouge(
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
                  return await controllers.utils.getSimpleDialouge(
                    title: 'Edit Sub-Category',
                    content: controllers.utils.dialogInput(
                        hintText: 'Type here',
                        initialValue: items[index],
                        onChnaged: (value) {
                          text = value;
                        }),
                    noPressed: () => Get.back(),
                    yesPressed: () {
                      if (controllers.utils.validateInputText(text) &&
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
                        controllers.utils.showSnackbar('Invalid entries');
                      }
                      text = '';
                    },
                  );
                }
              },
              child: controllers.utils.listTile(
                title: items[index],
                isTrailingNull: true,
              ),
            ),
          ),
        ),
      );
    });
  }
}
