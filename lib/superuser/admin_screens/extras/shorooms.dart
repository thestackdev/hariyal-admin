import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Showrooms extends StatefulWidget {
  @override
  _ShowroomsState createState() => _ShowroomsState();
}

class _ShowroomsState extends State<Showrooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Showrooms'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Center(
            child: IconButton(
              icon: Icon(MdiIcons.plusOutline),
              onPressed: () {
                addshowRoom(title: '', adress: '', latitude: '', longitude: '');
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('showrooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
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
                          MdiIcons.deleteOffOutline,
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
                      if (direction == DismissDirection.startToEnd) {
                        return await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              elevation: 9,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              title: const Text("Confirm"),
                              content: Text(
                                "Are you sure you wish to delete this Showroom?",
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () async {
                                      Firestore.instance
                                          .collection('showrooms')
                                          .document(snapshot
                                              .data.documents[index].documentID)
                                          .delete();
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text("DELETE")),
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return await addshowRoom(
                          title: snapshot.data.documents[index]['name'],
                          adress: snapshot.data.documents[index]['adress'],
                          latitude: snapshot.data.documents[index]['latitude'],
                          longitude: snapshot.data.documents[index]
                              ['longitude'],
                          document: snapshot.data.documents[index].documentID,
                        );
                      }
                    },
                    key: UniqueKey(),
                    child: ListTile(
                      title: Text(
                        'Name : ${snapshot.data.documents[index]['name']}',
                      ),
                      subtitle: Text(
                        'Adress : ${snapshot.data.documents[index]['adress']}',
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  addshowRoom({title, adress, latitude, longitude, document}) {
    final titleController = TextEditingController();
    final adressController = TextEditingController();
    final latitudeController = TextEditingController();
    final longitudeController = TextEditingController();

    titleController.text = title;
    adressController.text = adress;
    latitudeController.text = latitude;
    longitudeController.text = longitude;

    return showDialog(
      context: context,
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        title: Center(
          child: Text('Add Showroom'),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 27,
              vertical: 9,
            ),
            child: TextField(
              controller: titleController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: getDecoration('name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
            child: TextField(
              controller: adressController,
              maxLines: 5,
              keyboardType: TextInputType.text,
              decoration: getDecoration('adress'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
            child: TextField(
              controller: latitudeController,
              maxLines: 1,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: getDecoration('latitude'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
            child: TextField(
              controller: longitudeController,
              maxLines: 1,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: getDecoration('longitude'),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Center(
            child: RaisedButton(
              onPressed: () async {
                Fluttertoast.showToast(msg: 'Pushing data...');

                if (titleController.text.length > 0 &&
                    adressController.text.length > 0 &&
                    latitudeController.text.length > 0 &&
                    longitudeController.text.length > 0) {
                  Navigator.of(context).pop(false);
                  await Firestore.instance
                      .collection('showrooms')
                      .document(document)
                      .setData({
                    'name': titleController.text,
                    'adress': adressController.text,
                    'latitude': latitudeController.text,
                    'longitude': longitudeController.text,
                  });
                  Fluttertoast.showToast(msg: 'Done !');
                } else {
                  Fluttertoast.showToast(msg: 'Invalid entries !');
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text('Add Showroom'),
              color: Colors.red.shade300,
            ),
          )
        ],
      ),
    );
  }

  getDecoration(final labelname) {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: labelname,
      isDense: true,
      labelStyle: TextStyle(
        color: Colors.red.shade300,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 1.0,
      ),
      contentPadding: EdgeInsets.all(18),
      border: InputBorder.none,
      fillColor: Colors.grey.shade200,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
