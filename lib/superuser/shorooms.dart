import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'package:superuser/utils.dart';

class Showrooms extends StatefulWidget {
  @override
  _ShowroomsState createState() => _ShowroomsState();
}

class _ShowroomsState extends State<Showrooms> {
  Utils utils;
  Firestore firestore = Firestore.instance;
  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    addressController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    utils = context.watch<Utils>();

    return Scaffold(
      appBar: utils.appbar(
        'Showrooms',
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.plusOutline),
            onPressed: () => addshowRoom(),
          ),
        ],
      ),
      body: utils.container(
        child: DataStreamBuilder<QuerySnapshot>(
          stream: firestore.collection('showrooms').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.documents.length,
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
                        return await utils.simpleDialouge(
                          label: 'Confirm',
                          content: Text('Delete this Showroom ?'),
                          yesPressed: () async {
                            snapshot.documents[index].reference.delete();
                            Get.back();
                          },
                          noPressed: () => Get.back(),
                        );
                      } else {
                        return await addshowRoom(
                          title: snapshot.documents[index]['name'],
                          adress: snapshot.documents[index]['adress'],
                          latitude: snapshot.documents[index]['latitude'],
                          longitude: snapshot.documents[index]['longitude'],
                          document: snapshot.documents[index].documentID,
                        );
                      }
                    },
                    key: UniqueKey(),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          '${capitalize(snapshot.documents[index]['name'])}',
                          style: TextStyle(
                            color: Colors.red.shade300,
                          ),
                          textScaleFactor: 1.2,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          '${'Address : ' + capitalize(snapshot.documents[index]['adress'])}',
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  addshowRoom({
    title = '',
    adress = '',
    latitude = '',
    longitude = '',
    document = '',
  }) {
    titleController.text = title;
    addressController.text = adress;
    latitudeController.text = latitude;
    longitudeController.text = longitude;

    return utils.simpleDialouge(
      label: 'Add Showroom',
      yesPressed: () async {
        Get.back();
        utils.showSnackbar('Updating...');

        if (titleController.text.length > 0 &&
            addressController.text.length > 0 &&
            latitudeController.text.length > 0 &&
            longitudeController.text.length > 0) {
          await firestore.collection('showrooms').document(document).setData({
            'name': titleController.text,
            'adress': addressController.text,
            'latitude': latitudeController.text,
            'longitude': longitudeController.text,
          }, merge: true);
          utils.showSnackbar('Showroom Added');
        } else {
          utils.showSnackbar('Invalid Entries');
        }
      },
      noPressed: () => Get.back(),
      content: Column(
        children: <Widget>[
          utils.productInputText(
            label: 'Name',
            controller: titleController,
          ),
          utils.productInputText(
            label: 'Address',
            controller: addressController,
          ),
          utils.productInputText(
            label: 'latitude',
            controller: latitudeController,
            textInputType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
          ),
          utils.productInputText(
            label: 'longitude',
            controller: longitudeController,
            textInputType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
          ),
        ],
      ),
    );
  }
}
