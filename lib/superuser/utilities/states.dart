import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'package:superuser/superuser/utilities/areas.dart';
import 'package:superuser/utils.dart';

class States extends StatefulWidget {
  @override
  _StatesState createState() => _StatesState();
}

class _StatesState extends State<States> {
  List items = [];
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuerySnapshot extras = context.watch<QuerySnapshot>();
    final utils = context.watch<Utils>();
    DocumentSnapshot snapshot;

    if (extras == null) {
      return utils.blankScreenLoading();
    }

    for (DocumentSnapshot doc in extras.documents) {
      if (doc.documentID == 'locations') {
        items.clear();
        snapshot = doc;
        items.addAll(doc.data.keys);
        break;
      }
    }

    return Scaffold(
      appBar: utils.appbar(capitalize('States'), actions: [
        IconButton(
          icon: Icon(MdiIcons.plusOutline),
          onPressed: () => utils.getSimpleDialouge(
            title: 'Add State',
            content: utils.dialogInput(
              hintText: 'Type here',
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
              Areas(mapKey: items[index]),
            ),
          ),
        ),
      ),
    );
  }
}
