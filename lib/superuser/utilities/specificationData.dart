import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

class SpecificationData extends StatelessWidget {
  final String category = Get.arguments;
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    List items = [];
    return Obx(() {
      final DocumentSnapshot snapshot = Controllers.to.specifications.value;
      if (snapshot.data[category] != null) {
        items = snapshot.data[category];
      }

      String text = '';

      deleteSpecification(String data) {
        /*  firestore
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
    }); */
      }

      editSpecification(String oldData, String newData) {
        /* firestore
        .collection('products')
        .where('category.subCategory', isEqualTo: oldData)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({'category.subCategory': newData});
      });
    }); */
      }

      addSpecification() {
        if (controllers.utils.validateInputText(text) &&
            !items.contains(text.toLowerCase())) {
          if (snapshot == null) {
            controllers.extras.document('specifications').setData({
              category: FieldValue.arrayUnion([text.toLowerCase()])
            });
          } else {
            snapshot.reference.updateData({
              category: FieldValue.arrayUnion([text.toLowerCase()])
            });
          }

          Get.back();
          controllers.utils.showSnackbar('Specification Added');
        } else {
          Get.back();
          controllers.utils.showSnackbar('Invalid entries');
        }
        text = '';
      }

      return Scaffold(
        appBar: controllers.utils.appbar(category, actions: [
          IconButton(
              icon: Icon(OMIcons.plusOne),
              onPressed: () {
                controllers.utils.getSimpleDialouge(
                  title: 'Add Specifications in $category',
                  content: controllers.utils.dialogInput(
                      hintText: 'Type here',
                      onChnaged: (value) {
                        text = value;
                      }),
                  noPressed: () => Get.back(),
                  yesPressed: () => addSpecification(),
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
                    content: Text('Delete this Specification ?'),
                    yesPressed: () {
                      deleteSpecification(items[index]);

                      snapshot.reference.updateData({
                        category: FieldValue.arrayRemove([items[index]])
                      });
                      Get.back();
                    },
                    noPressed: () => Get.back(),
                  );
                } else {
                  return await controllers.utils.getSimpleDialouge(
                    title: 'Edit Specification',
                    content: controllers.utils.dialogInput(
                        hintText: 'Type here',
                        initialValue: items[index],
                        onChnaged: (value) {
                          text = value;
                        }),
                    noPressed: () => Get.back(),
                    yesPressed: () {
                      Get.back();
                      if (controllers.utils.validateInputText(text) &&
                          text != items[index] &&
                          !items.contains(text.toLowerCase())) {
                        editSpecification(items[index], text);
                        snapshot.reference.updateData({
                          category: FieldValue.arrayRemove([items[index]]),
                        });
                        snapshot.reference.updateData({
                          category: FieldValue.arrayUnion([text]),
                        });
                      } else {
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
