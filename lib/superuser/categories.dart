import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'package:superuser/superuser/sub_categories.dart';
import 'package:superuser/utils.dart';

class CategoriesScreen extends StatefulWidget {
  final type;

  const CategoriesScreen({Key key, this.type}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List items = [];
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    final utils = context.watch<Utils>();
    DocumentSnapshot snapshot;

    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == widget.type) {
        items.clear();
        snapshot = doc;
        items.addAll(doc.data.keys);
        handleState();
        break;
      }
    }

    return Scaffold(
      appBar: utils.appbar(capitalize(widget.type), actions: [
        IconButton(
          icon: Icon(MdiIcons.plusOutline),
          onPressed: () => utils.simpleDialouge(
            label: 'Add Category',
            content: utils.productInputText(
              label: 'Type here',
              controller: textController,
            ),
            noPressed: () => Get.back(),
            yesPressed: () {
              Get.back();
              if (textController.text.length > 0 &&
                  !items.contains(textController.text.toLowerCase())) {
                snapshot.reference
                    .updateData({textController.text.toLowerCase(): []});
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
            onTap: () => Get.to(
              SubCategories(
                mapKey: items[index],
                docID: widget.type,
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleState() => (mounted) ?? setState(() => null);
}
