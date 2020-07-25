import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'package:superuser/superuser/utilities/specifications.dart';
import 'package:superuser/utils.dart';

class SubCategories extends StatefulWidget {
  final mapKey;

  const SubCategories({Key key, this.mapKey}) : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  final textController = TextEditingController();
  List items = [];
  DocumentSnapshot snapshot;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    final utils = context.watch<Utils>();
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == 'category') {
        items.clear();
        snapshot = doc;
        if (doc.data[widget.mapKey] != null) {
          items.addAll(doc.data[widget.mapKey]);
        }
        handleState();
        break;
      }
    }

    return Scaffold(
      appBar: utils.appbar(capitalize(widget.mapKey), actions: [
        IconButton(
          icon: Icon(MdiIcons.plusOutline),
          onPressed: () => utils.getSimpleDialouge(
            title: 'Add Sub-Category',
            content: utils.dialogInput(
              hintText: 'Type here',
              controller: textController,
            ),
            noPressed: () => Get.back(),
            yesPressed: () {
              Get.back();
              if (textController.text.length > 0 &&
                  !items.contains(textController.text.toLowerCase())) {
                snapshot.reference.updateData({
                  '${widget.mapKey}':
                      FieldValue.arrayUnion([textController.text.toLowerCase()])
                });
              } else {
                utils.showSnackbar('Invalid entries');
              }
              textController.clear();
            },
          ),
        ),
      ]),
      body: utils.container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => utils.listTile(
            title: capitalize(items[index]),
            onTap: () => Get.to(Specifications(
              mapKey: items[index],
            )),
            isTrailingNull: false,
          ),
        ),
      ),
    );
  }

  handleState() => (mounted) ?? setState(() => null);
}
