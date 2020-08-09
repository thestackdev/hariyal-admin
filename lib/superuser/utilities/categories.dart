import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

class CategoriesScreen extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final DocumentSnapshot snapshot = controllers.categories.value;
      final List items = snapshot.data.keys.toList();

      String text = '';

      void addCategory() {
        if (controllers.utils.validateInputText(text) &&
            !items.contains(text.toLowerCase())) {
          snapshot.reference.updateData({text: []});
          Get.back();
          controllers.utils.snackbar('Category Added');
        } else {
          Get.back();
          controllers.utils.snackbar('Invalid entries');
        }

        text = '';
      }

      void deleteCategory(String data) {
        controllers.products
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

      void editCategory(String oldData, String newData) {
        controllers.products
            .where('category.category', isEqualTo: oldData)
            .getDocuments()
            .then((value) {
          value.documents.forEach((element) {
            element.reference.updateData({'category.category': newData});
          });
        });
      }

      return controllers.utils.root(
        label: 'Categories',
        actions: [
          IconButton(
            icon: Icon(OMIcons.plusOne),
            onPressed: () => controllers.utils.getSimpleDialouge(
              title: 'Add Category',
              content: controllers.utils.dialogInput(
                  hintText: 'Type here',
                  onChnaged: (value) {
                    text = value.trim().toLowerCase();
                  }),
              noPressed: () => Get.back(),
              yesPressed: () => addCategory(),
            ),
          ),
        ],
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => controllers.utils.dismissible(
            key: UniqueKey(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                return await controllers.utils.getSimpleDialouge(
                  title: 'Confirm',
                  content: Text('Delete this Category ?'),
                  yesPressed: () {
                    deleteCategory(items[index]);
                    snapshot.reference
                        .updateData({items[index]: FieldValue.delete()});
                    Get.back();
                  },
                  noPressed: () => Get.back(),
                );
              } else {
                return await controllers.utils.getSimpleDialouge(
                  title: 'Edit Category',
                  content: controllers.utils.dialogInput(
                      hintText: 'Type here',
                      initialValue: items[index],
                      onChnaged: (value) {
                        text = value.trim().toLowerCase();
                      }),
                  noPressed: () => Get.back(),
                  yesPressed: () {
                    if (controllers.utils.validateInputText(text) &&
                        text != items[index] &&
                        !items.contains(text.toLowerCase())) {
                      List tempData = snapshot.data[items[index]];

                      snapshot.reference.updateData({text: tempData});
                      snapshot.reference.updateData(
                        {items[index]: FieldValue.delete()},
                      );

                      editCategory(items[index], text);
                      Get.back();
                    } else {
                      Get.back();
                      controllers.utils.snackbar('Invalid entries');
                    }
                    text = '';
                  },
                );
              }
            },
            child: controllers.utils.listTile(
              title: items[index],
              onTap: () =>
                  Get.toNamed('/sub_categories', arguments: items[index]),
            ),
          ),
        ),
      );
    });
  }
}
