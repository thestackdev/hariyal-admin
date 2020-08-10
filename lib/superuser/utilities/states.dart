import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

class States extends StatefulWidget {
  @override
  _StatesState createState() => _StatesState();
}

class _StatesState extends State<States> {
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
      stream: controllers.locationsStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List.generate(snapshot.data.keys.length, (index) {
            isExpandedItem.add(false);
          });
        }

        void addState(String data) {
          if (controllers.utils.validateInputText(data) &&
              !snapshot.data.keys.contains(data)) {
            snapshot.reference.updateData({data: FieldValue.arrayUnion([])});
            Get.back();
            controllers.utils.snackbar('$data Added');
            textController.clear();
          } else {
            Get.back();
            controllers.utils.snackbar('Invalid entries');
          }
        }

        void deleteState(String data) => controllers.products
            .where('location.state', isEqualTo: data)
            .getDocuments()
            .then(
              (value) => value.documents.forEach((element) => element.reference
                      .updateData({
                    'location.state': null,
                    'location.area': null,
                    'isDeleted': true
                  })),
            );

        void editState(String oldData, String newData) => controllers.products
            .where('location.state', isEqualTo: oldData)
            .getDocuments()
            .then((value) => value.documents.forEach(
                  (element) =>
                      element.reference.updateData({'location.state': newData}),
                ));

        addArea(String key, String text, List list) {
          if (controllers.utils.validateInputText(text) &&
              !list.contains(text)) {
            snapshot.reference.updateData({
              key: FieldValue.arrayUnion([text])
            });
            Get.back();
            controllers.utils.snackbar('$text Added');
          } else {
            Get.back();
            controllers.utils.snackbar('Invalid entries');
          }
          textController.clear();
        }

        deleteArea(String data) => controllers.products
            .where('location.area', isEqualTo: data)
            .getDocuments()
            .then((value) => value.documents.forEach(
                  (element) => element.reference
                      .updateData({'location.area': null, 'isDeleted': true}),
                ));

        editArea(String oldData, String newData) => controllers.products
            .where('location.area', isEqualTo: oldData)
            .getDocuments()
            .then((value) => value.documents.forEach(
                  (element) =>
                      element.reference.updateData({'location.area': newData}),
                ));

        return controllers.utils.root(
          label: 'Locations',
          actions: [
            IconButton(
              icon: const Icon(OMIcons.add),
              onPressed: () => controllers.utils.getSimpleDialouge(
                title: 'Add Location',
                content: controllers.utils.dialogInput(
                  hintText: 'Type here',
                  controller: textController,
                ),
                noPressed: () => Get.back(),
                yesPressed: () =>
                    addState(textController.text.trim().toLowerCase()),
              ),
            ),
          ],
          child: (snapshot == null || snapshot.data == null)
              ? controllers.utils.error('No Locations Found')
              : SingleChildScrollView(
                  child: ExpansionPanelList(
                    dividerColor: Colors.transparent,
                    expansionCallback: (panelIndex, isExpanded) {
                      isExpandedItem.clear();
                      for (int i = 0; i < snapshot.data.keys.length; i++) {
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
                                      'Delete ${snapshot.data.keys.elementAt(index)} ?',
                                  yesPressed: () {
                                    deleteState(
                                        snapshot.data.keys.elementAt(index));
                                    snapshot.reference.updateData({
                                      snapshot.data.keys.elementAt(index):
                                          FieldValue.delete()
                                    });
                                    Get.back();
                                  },
                                  noPressed: () => Get.back(),
                                );
                              } else {
                                textController.text =
                                    snapshot.data.keys.elementAt(index);
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
                                      List tempData = snapshot.data[
                                          snapshot.data.keys.elementAt(index)];

                                      snapshot.reference.updateData({
                                        textController.text
                                            .trim()
                                            .toLowerCase(): tempData
                                      });
                                      snapshot.reference.updateData({
                                        snapshot.data.keys.elementAt(index):
                                            FieldValue.delete()
                                      });

                                      editState(
                                          snapshot.data.keys.elementAt(index),
                                          textController.text
                                              .trim()
                                              .toLowerCase());
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
                                                'Add Area in ${snapshot.data.keys.elementAt(index)}',
                                            content:
                                                controllers.utils.dialogInput(
                                              controller: textController,
                                              hintText: 'Type here',
                                            ),
                                            noPressed: () => Get.back(),
                                            yesPressed: () => addArea(
                                                snapshot.data.keys
                                                    .elementAt(index),
                                                textController.text
                                                    .trim()
                                                    .toLowerCase(),
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
                                      deleteArea(snapshot.data[snapshot
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
                                        editArea(
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
