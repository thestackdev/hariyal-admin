import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/utils.dart';

class ExtraIdentifier extends StatefulWidget {
  final identifier;

  const ExtraIdentifier({Key key, this.identifier}) : super(key: key);

  @override
  _ExtraIdentifierState createState() => _ExtraIdentifierState();
}

class _ExtraIdentifierState extends State<ExtraIdentifier> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('extras')
          .document('${widget.identifier}')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.red,
            appBar: AppBar(
              title: Text(
                widget.identifier.toUpperCase(),
              ),
              centerTitle: true,
              elevation: 0,
              actions: <Widget>[
                Center(
                  child: IconButton(
                    icon: Icon(MdiIcons.plusOutline),
                    onPressed: () {
                      if (snapshot.data.data == null) {
                        addCategoryDialouge([]);
                      } else {
                        addCategoryDialouge(
                          snapshot.data.data['${widget.identifier}_array'],
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: Utils().getBoxDecoration(),
              child: ListView.builder(
                itemCount: snapshot.data.data == null
                    ? 0
                    : snapshot.data.data['${widget.identifier}_array'].length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.grey.shade100,
                    ),
                    child: Dismissible(
                      background: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.red,
                        ),
                        child: ListTile(
                          leading: Icon(
                            MdiIcons.deleteOutline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.blue,
                        ),
                        child: ListTile(
                          trailing: Icon(
                            MdiIcons.pencilOutline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          final textController = TextEditingController();
                          textController.text = snapshot
                              .data.data['${widget.identifier}_array'][index];
                          return await showDialog(
                            context: context,
                            child: SimpleDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(9),
                                      alignment: Alignment.center,
                                      child: Text('Edit Category'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 27, vertical: 9),
                                      child: TextField(
                                        controller: textController,
                                        maxLines: 1,
                                        keyboardType: TextInputType.text,
                                        decoration: utils.getDecoration(
                                          label: 'Full name',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('update'),
                                      onPressed: () {
                                        if (textController.text.length > 0) {
                                          Firestore.instance
                                              .collection('extras')
                                              .document('${widget.identifier}')
                                              .updateData(
                                            {
                                              '${widget.identifier}_array':
                                                  FieldValue.arrayRemove(
                                                [
                                                  snapshot.data.data[
                                                          '${widget.identifier}_array']
                                                      [index],
                                                ],
                                              )
                                            },
                                          );
                                          Firestore.instance
                                              .collection('extras')
                                              .document('${widget.identifier}')
                                              .setData(
                                            {
                                              '${widget.identifier}_array':
                                                  FieldValue.arrayUnion(
                                                [
                                                  textController.text
                                                      .toLowerCase()
                                                ],
                                              )
                                            },
                                            merge: true,
                                          );

                                          Navigator.of(context).pop(false);
                                        } else {
                                          Navigator.of(context).pop(false);
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Invalid Arguments or field is alreay present');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                elevation: 9,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                title: Text("Confirm"),
                                content: Text(
                                    "Are you sure you wish to delete this ${widget.identifier}?"),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () async {
                                      Firestore.instance
                                          .collection('extras')
                                          .document('${widget.identifier}')
                                          .updateData(
                                        {
                                          '${widget.identifier}_array':
                                              FieldValue.arrayRemove(
                                            [
                                              snapshot.data.data[
                                                      '${widget.identifier}_array']
                                                  [index]
                                            ],
                                          ),
                                        },
                                      );
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text("DELETE"),
                                  ),
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      key: UniqueKey(),
                      child: ListTile(
                        title: Center(
                          child: Text(
                            snapshot
                                .data.data['${widget.identifier}_array'][index]
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return Center(
            child: SpinKitRing(
              color: Colors.red.shade300,
              lineWidth: 5,
            ),
          );
        }
      },
    );
  }

  addCategoryDialouge(List list) async {
    final name = TextEditingController();
    return showDialog(
      context: context,
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        title: Center(
          child: Text(
            'Add ${widget.identifier.toUpperCase()}',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 27, vertical: 9),
            child: TextField(
                controller: name,
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: utils.getDecoration(
                  label: 'Enter Data',
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.red.shade300,
                  ),
                ),
                onPressed: () {
                  if (name.text.length > 0 &&
                      !list.contains(name.text.toLowerCase())) {
                    Firestore.instance
                        .collection('extras')
                        .document('${widget.identifier}')
                        .setData({
                      '${widget.identifier}_array':
                      FieldValue.arrayUnion([name.text.toLowerCase()])
                    }, merge: true);
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Invalid Arguments or field is alreay present',
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
