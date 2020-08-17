import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

class SpecificationData extends StatefulWidget {
  @override
  _SpecificationDataState createState() => _SpecificationDataState();
}

class _SpecificationDataState extends State<SpecificationData> {
  final String category = Get.arguments;
  final controllers = Controllers.to;
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controllers.utils.streamBuilder<DocumentSnapshot>(
      stream: controllers.specificationsStream,
      builder: (context, snapshot) {
        addSpecification(String text) {
          if (snapshot.data[category] == null) {
            snapshot.reference.updateData({
              category: FieldValue.arrayUnion([text])
            });
            Get.back();
            controllers.utils.snackbar('Specification Added');
          } else {
            if (controllers.utils.validateInputText(text) &&
                !snapshot.data[category].contains(text)) {
              if (snapshot == null) {
                controllers.extras.document('specifications').setData({
                  category: FieldValue.arrayUnion([text])
                });
              } else {
                snapshot.reference.updateData({
                  category: FieldValue.arrayUnion([text])
                });
              }

              Get.back();
              controllers.utils.snackbar('Specification Added');
            } else {
              Get.back();
              controllers.utils.snackbar('Invalid entries');
            }
          }
        }

        return controllers.utils.root(
          label: category,
          actions: [
            IconButton(
                icon: const Icon(OMIcons.add),
                onPressed: () {
                  controllers.utils.getSimpleDialouge(
                    title: 'Add Specifications in $category',
                    content: controllers.utils.dialogInput(
                      hintText: 'Type here',
                      controller: textController,
                    ),
                    noPressed: () => Get.back(),
                    yesPressed: () => addSpecification(
                        textController.text.trim().toLowerCase()),
                  );
                }),
          ],
          child: (snapshot?.data[category] == null)
              ? controllers.utils.error('No Specifications')
              : ListView.builder(
                  itemCount: snapshot?.data[category]?.length,
                  itemBuilder: (context, index) =>
                      controllers.utils.dismissible(
                    key: UniqueKey(),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        return await controllers.utils.getSimpleDialouge(
                          title: 'Confirm',
                          content: Text('Delete this Specification ?'),
                          yesPressed: () {
                            snapshot.reference.updateData({
                              category: FieldValue.arrayRemove(
                                  [snapshot.data[category][index]])
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
                            initialValue: snapshot.data[category][index],
                            controller: textController,
                          ),
                          noPressed: () => Get.back(),
                          yesPressed: () {
                            Get.back();
                            if (controllers.utils
                                    .validateInputText(textController.text) &&
                                textController.text !=
                                    snapshot.data[category][index] &&
                                !snapshot.data[category].contains(
                                    textController.text.toLowerCase())) {
                              snapshot.reference.updateData({
                                category: FieldValue.arrayRemove(
                                    [snapshot.data[category][index]]),
                              });
                              snapshot.reference.updateData({
                                category: FieldValue.arrayUnion(
                                    [textController.text.trim().toLowerCase()]),
                              });
                            } else {
                              controllers.utils.snackbar('Invalid entries');
                            }
                            textController.clear();
                          },
                        );
                      }
                    },
                    child: controllers.utils.listTile(
                      title: snapshot?.data[category][index],
                      isTrailingNull: true,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
