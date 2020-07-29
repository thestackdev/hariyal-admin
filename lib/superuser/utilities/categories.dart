import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/superuser/utilities/sub_categories.dart';
import 'package:superuser/utils.dart';

class CategoriesScreen extends StatelessWidget {
  final CollectionReference products =
      Firestore.instance.collection('products');
  final Controllers controllers = Get.find();
  final Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    String text = '';
    List items = [];
    DocumentSnapshot snapshot;

    addCategory() {
      if (utils.validateInputText(text) &&
          !items.contains(text.toLowerCase())) {
        snapshot.reference.updateData({text.toLowerCase(): []});
        Get.back();
        utils.showSnackbar('Category Added');
      } else {
        Get.back();
        utils.showSnackbar('Invalid entries');
      }

      text = '';
    }

    deleteCategory(String data) {
      products
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
      products
          .where('category.category', isEqualTo: oldData)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          element.reference.updateData({'category.category': newData});
        });
      });
    }

    return Scaffold(
      appBar: utils.appbar('Categories', actions: [
        IconButton(
          icon: Icon(MdiIcons.plusOutline),
          onPressed: () => utils.getSimpleDialouge(
            title: 'Add Category',
            content: utils.dialogInput(
                hintText: 'Type here',
                onChnaged: (value) {
                  text = value;
                }),
            noPressed: () => Get.back(),
            yesPressed: () => addCategory(),
          ),
        ),
      ]),
      body: utils.container(
        child: Obx(() {
          items = controllers.categories.value.data.keys.toList();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => utils.dismissible(
              key: UniqueKey(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  return await utils.getSimpleDialouge(
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
                  return await utils.getSimpleDialouge(
                    title: 'Edit Category',
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

                        editCategory(items[index], text);
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
                onTap: () => Get.to(SubCategories(
                  mapKey: items[index],
                )),
              ),
            ),
          );
        }),
      ),
    );
  }
}
