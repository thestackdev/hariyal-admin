import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

class States extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final DocumentSnapshot snapshot = Controllers.to.locations.value;
      final List items = snapshot.data.keys.toList();
      String text = '';

      addState() {
        if (controllers.utils.validateInputText(text) &&
            !items.contains(text.toLowerCase())) {
          snapshot.reference.updateData({text.toLowerCase(): []});
          Get.back();
          controllers.utils.showSnackbar('State Added');
        } else {
          Get.back();
          controllers.utils.showSnackbar('Invalid entries');
        }
        text = '';
      }

      deleteState(String data) {
        controllers.products
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
        controllers.showrooms
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
        controllers.products
            .where('location.state', isEqualTo: oldData)
            .getDocuments()
            .then((value) {
          value.documents.forEach((element) {
            element.reference.updateData({'location.state': newData});
          });
        });
        controllers.showrooms
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

      return Scaffold(
        appBar: controllers.utils.appbar('States', actions: [
          IconButton(
            icon: Icon(OMIcons.plusOne),
            onPressed: () => controllers.utils.getSimpleDialouge(
              title: 'Add State',
              content: controllers.utils.dialogInput(
                  hintText: 'Type here',
                  onChnaged: (value) {
                    text = value.trim().toLowerCase();
                  }),
              noPressed: () => Get.back(),
              yesPressed: () => addState(),
            ),
          ),
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
                  return await controllers.utils.getSimpleDialouge(
                    title: 'Edit State',
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
                        snapshot.reference
                            .updateData({items[index]: FieldValue.delete()});
                        editState(items[index], text);
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
                onTap: () => Get.toNamed('/areas', arguments: items[index]),
              ),
            ),
          ),
        ),
      );
    });
  }
}
