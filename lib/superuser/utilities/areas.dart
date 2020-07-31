import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/utils.dart';

class Areas extends StatelessWidget {
  final String mapKey = Get.arguments;
  final utils = Utils();
  final products = Firestore.instance.collection('products');
  final showrooms = Firestore.instance.collection('showrooms');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final DocumentSnapshot snapshot = Controllers.to.locations.value;
      final items = snapshot.data[mapKey];
      String text = '';

      addArea() {
        if (utils.validateInputText(text) &&
            !items.contains(text.toLowerCase())) {
          snapshot.reference.updateData({
            mapKey: FieldValue.arrayUnion([text.toLowerCase()])
          });
          Get.back();
          utils.showSnackbar('Area Added');
        } else {
          Get.back();
          utils.showSnackbar('Invalid entries');
        }

        text = '';
      }

      deleteArea(String data) {
        products
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
        showrooms.where('area', isEqualTo: data).getDocuments().then((value) {
          value.documents.forEach((element) {
            element.reference.updateData({
              'area': null,
            });
          });
        });
      }

      editArea(String oldData, String newData) {
        products
            .where('location.area', isEqualTo: oldData)
            .getDocuments()
            .then((value) {
          value.documents.forEach((element) {
            element.reference.updateData({'location.area': newData});
          });
        });
        showrooms
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

      return Scaffold(
        appBar: utils.appbar(mapKey, actions: [
          IconButton(
            icon: Icon(MdiIcons.plusOutline),
            onPressed: () => utils.getSimpleDialouge(
              title: 'Add Areas',
              content: utils.dialogInput(
                  hintText: 'Type here',
                  onChnaged: (value) {
                    text = value;
                  }),
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
                        mapKey: FieldValue.arrayRemove([items[index]]),
                      });
                      Get.back();
                    },
                    noPressed: () => Get.back(),
                  );
                } else {
                  return await utils.getSimpleDialouge(
                    title: 'Edit Area',
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
                        editArea(items[index], text);
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
              child: utils.listTile(title: items[index], isTrailingNull: false),
            ),
          ),
        ),
      );
    });
  }
}
