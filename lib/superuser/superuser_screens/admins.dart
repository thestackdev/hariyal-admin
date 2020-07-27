import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/admin_extras/admin_tabs.dart';
import 'package:superuser/utils.dart';

class Admins extends StatefulWidget {
  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  bool isQueryActive = false;
  Firestore firestore = Firestore.instance;
  int count = 30;
  String searchValue;
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return Scaffold(
      appBar: utils.appbar('Admins'),
      body: utils.container(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(9),
              color: Colors.red,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: utils.inputTextStyle(),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        searchValue = value;
                        isQueryActive = true;
                        handleState();
                      },
                      onChanged: (value) {
                        searchValue = value;
                        isQueryActive = true;
                        handleState();
                      },
                      maxLines: 1,
                      decoration: getDecoration(),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: IconButton(
                      padding: EdgeInsets.all(9),
                      color: Colors.white,
                      icon: Icon(
                        isQueryActive
                            ? MdiIcons.closeOutline
                            : MdiIcons.accountSearchOutline,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (isQueryActive) {
                          isQueryActive = false;
                          searchValue = null;
                          controller.clear();
                        } else if (controller.text.length > 0) {
                          isQueryActive = true;
                          searchValue = controller.text;
                        }
                        handleState();
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: DataStreamBuilder<QuerySnapshot>(
                errorBuilder: (context, error) => utils.nullWidget(error),
                loadingBuilder: (context) => utils.progressIndicator(),
                stream: firestore
                    .collection('admin')
                    .where('name', isEqualTo: searchValue?.toLowerCase())
                    .limit(count)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.documents.length == 0) {
                    return utils.nullWidget('No Admins found !');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return utils.listTile(
                          title: snapshot.documents[index]['name'],
                          subtitle:
                              'Since ${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(snapshot.documents[index]['since']), format: AmericanDateFormats.dayOfWeek)}',
                          onTap: () => Get.to(
                            AdminExtras(
                              adminUid: snapshot.documents[index].documentID,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDecoration() {
    return InputDecoration(
      isDense: true,
      hintText: 'Search by name',
      contentPadding: EdgeInsets.all(12),
      border: InputBorder.none,
      fillColor: Colors.grey.shade100,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide.none,
      ),
    );
  }

  handleState() => (mounted) ? setState(() => null) : null;
}
