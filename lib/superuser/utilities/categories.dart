import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final controllers = Controllers.to;
  final textController = TextEditingController();
  List<bool> isExpandedItem = [];

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => controllers.utils.streamBuilder<
          DocumentSnapshot>(
      stream: controllers.categoryStream,
      builder: (context, snapshot) {
        if (snapshot?.data != null) {
          List.generate(snapshot?.data?.keys?.length, (index) {
            isExpandedItem.add(false);
          });
        }

        void addCategory(String data) {
          if (controllers.utils.validateInputText(data)) {
            if (snapshot?.data == null) {
              controllers.extras
                  .document('category')
                  .setData({data: FieldValue.arrayUnion([])});
              Get.back();
              controllers.utils.snackbar('$data Added');
              textController.clear();
            } else {
              if (!snapshot.data.keys.contains(data)) {
                snapshot.reference
                    .updateData({data: FieldValue.arrayUnion([])});
                Get.back();
                controllers.utils.snackbar('$data Added');
                textController.clear();
              } else {
                Get.back();
                controllers.utils.snackbar('Invalid entries');
              }
            }
          }
        }

        void deleteCategory(String data) => controllers.products
            .where('category.category', isEqualTo: data)
            .getDocuments()
            .then(
              (value) => value.documents.forEach((element) => element.reference
                      .updateData({
                    'category.category': null,
                    'category.subCategory': null,
                    'isDeleted': true
                  })),
            );

        void editCategory(String oldData) => controllers.products
            .where('category.category', isEqualTo: oldData)
            .getDocuments()
            .then((value) => value.documents.forEach(
                  (element) => element.reference.updateData({
                    'category.category':
                        textController.text.trim().toLowerCase()
                  }),
                ));

        addSubCategory(String key, String text, List list) {
          if (controllers.utils.validateInputText(text) &&
              !list.contains(text.trim().toLowerCase())) {
            snapshot.reference.updateData({
              key: FieldValue.arrayUnion([text.trim().toLowerCase()])
            });
            Get.back();
            controllers.utils.snackbar('Subcategory Added');
          } else {
            Get.back();
            controllers.utils.snackbar('Invalid entries');
          }
          textController.clear();
        }

        deleteSubCategory(String data) => controllers.products
            .where('category.subCategory', isEqualTo: data)
            .getDocuments()
            .then((value) => value.documents.forEach(
                  (element) => element.reference.updateData(
                      {'category.subCategory': null, 'isDeleted': true}),
                ));

        editSubCategory(String oldData, String newData) => controllers.products
            .where('category.subCategory', isEqualTo: oldData)
            .getDocuments()
            .then((value) => value.documents.forEach(
                  (element) => element.reference
                      .updateData({'category.subCategory': newData}),
                ));

        return controllers.utils.root(
          label: 'Categories',
          actions: [
            IconButton(
              icon: const Icon(OMIcons.add),
              onPressed: () => controllers.utils.getSimpleDialouge(
                title: 'Add Category',
                content: controllers.utils.dialogInput(
                  hintText: 'Type here',
                  controller: textController,
                ),
                noPressed: () => Get.back(),
                yesPressed: () =>
                    addCategory(textController.text.trim().toLowerCase()),
              ),
            ),
          ],
          child: (snapshot?.data == null)
              ? controllers.utils.error('No Categories Found')
              : SingleChildScrollView(
                  child: ExpansionPanelList(
                    dividerColor: Colors.transparent,
                    expansionCallback: (panelIndex, isExpanded) {
                      isExpandedItem.clear();
                      for (int i = 0; i < snapshot?.data?.keys?.length; i++) {
                        isExpandedItem.add(false);
                      }
                      isExpandedItem.removeAt(panelIndex);
                      isExpandedItem.insert(panelIndex, !isExpanded);
                      setState(() {});
                    },
                    children: List.generate(
                      snapshot?.data?.keys?.length ?? 0,
                      (index) => ExpansionPanel(
                        isExpanded: isExpandedItem[index],
                        headerBuilder: (context, isExpanded) {
                          return controllers.utils.dismissible(
                            key: UniqueKey(),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                return await controllers.utils
                                    .getSimpleDialougeForNoContent(
                                  title:
                                      'Delete ${snapshot?.data?.keys?.elementAt(index)} ?',
                                  yesPressed: () {
                                    deleteCategory(
                                        snapshot?.data?.keys?.elementAt(index));
                                    snapshot?.reference?.updateData({
                                      snapshot?.data?.keys?.elementAt(index):
                                          FieldValue.delete()
                                    });
                                    Get.back();
                                  },
                                  noPressed: () => Get.back(),
                                );
                              } else {
                                textController.text =
                                    snapshot?.data?.keys?.elementAt(index);
                                return await controllers.utils
                                    .getSimpleDialouge(
                                  title:
                                      'Edit ${snapshot.data.keys.elementAt(index)}',
                                  content: controllers.utils.dialogInput(
                                    hintText: 'Type here',
                                    controller: textController,
                                  ),
                                  noPressed: () => Get.back(),
                                  yesPressed: () {
                                    if (controllers.utils.validateInputText(
                                            textController.text
                                                .trim()
                                                .toLowerCase()) &&
                                        !snapshot.data.keys.contains(
                                            textController.text
                                                .trim()
                                                .toLowerCase())) {
                                      List tempData = snapshot?.data[snapshot
                                          ?.data?.keys
                                          ?.elementAt(index)];

                                      snapshot?.reference?.updateData({
                                        textController.text
                                            .trim()
                                            .toLowerCase(): tempData
                                      });
                                      snapshot?.reference?.updateData({
                                        snapshot?.data?.keys?.elementAt(index):
                                            FieldValue.delete()
                                      });

                                      editCategory(snapshot?.data?.keys
                                          ?.elementAt(index));
                                      Get.back();
                                    } else {
                                      Get.back();
                                      controllers.utils
                                          .snackbar('Invalid entries');
                                    }
                                    textController.clear();
                                  },
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      GetUtils.capitalizeFirst(
                                          snapshot.data.keys.elementAt(index)),
                                      style: Get.textTheme.headline2),
                                  if (isExpandedItem[index]) ...[
                                    IconButton(
                                        icon: Icon(OMIcons.add),
                                        onPressed: () {
                                          controllers.utils.getSimpleDialouge(
                                            title:
                                                'Add SubCategory in ${snapshot.data.keys.elementAt(index)}',
                                            content:
                                                controllers.utils.dialogInput(
                                              controller: textController,
                                              hintText: 'Type here',
                                            ),
                                            noPressed: () => Get.back(),
                                            yesPressed: () => addSubCategory(
                                                snapshot.data.keys
                                                    .elementAt(index),
                                                textController.text,
                                                snapshot.data[snapshot.data.keys
                                                    .elementAt(index)]),
                                          );
                                        }),
                                  ]
                                ],
                              ),
                            ),
                          );
                        },
                        body: ListView(
                          shrinkWrap: true,
                          children: List.generate(
                            snapshot.data[snapshot.data.keys.elementAt(index)]
                                .length,
                            (subindex) => controllers.utils.dismissible(
                              key: UniqueKey(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  return await controllers.utils
                                      .getSimpleDialougeForNoContent(
                                    title:
                                        'Delete ${snapshot.data[snapshot.data.keys.elementAt(index)][subindex]} from ${snapshot.data.keys.elementAt(index)} ?',
                                    yesPressed: () {
                                      deleteSubCategory(snapshot.data[snapshot
                                          .data.keys
                                          .elementAt(index)][subindex]);

                                      snapshot.reference.updateData({
                                        snapshot.data.keys.elementAt(index):
                                            FieldValue.arrayRemove([
                                          snapshot.data[snapshot.data.keys
                                              .elementAt(index)][subindex]
                                        ])
                                      });

                                      Get.back();
                                    },
                                    noPressed: () => Get.back(),
                                  );
                                } else {
                                  textController.text = snapshot.data[
                                          snapshot.data.keys.elementAt(index)]
                                      [subindex];
                                  return await controllers.utils
                                      .getSimpleDialouge(
                                    title:
                                        'Edit ${snapshot.data[snapshot.data.keys.elementAt(index)][subindex]} in ${snapshot.data.keys.elementAt(index)}',
                                    content: controllers.utils.dialogInput(
                                      hintText: 'Type here',
                                      controller: textController,
                                    ),
                                    noPressed: () => Get.back(),
                                    yesPressed: () {
                                      if (controllers.utils.validateInputText(
                                              textController.text
                                                  .trim()
                                                  .toLowerCase()) &&
                                          !snapshot.data.keys.contains(
                                              textController.text
                                                  .trim()
                                                  .toLowerCase())) {
                                        editSubCategory(
                                            snapshot.data[snapshot.data.keys
                                                .elementAt(index)][subindex],
                                            textController.text);
                                        snapshot.reference.updateData({
                                          snapshot.data.keys.elementAt(index):
                                              FieldValue.arrayRemove([
                                            snapshot.data[snapshot.data.keys
                                                .elementAt(index)][subindex]
                                          ]),
                                        });
                                        snapshot.reference.updateData({
                                          snapshot.data.keys.elementAt(index):
                                              FieldValue.arrayUnion([
                                            textController.text
                                                .trim()
                                                .toLowerCase()
                                          ]),
                                        });
                                        Get.back();
                                      } else {
                                        Get.back();
                                        controllers.utils
                                            .snackbar('Invalid entries');
                                      }
                                      textController.clear();
                                    },
                                  );
                                }
                              },
                              child: controllers.utils.listTile(
                                  title: snapshot.data[snapshot.data.keys
                                      .elementAt(index)][subindex],
                                  textscalefactor: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      });
}
