import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/change_password.dart';
import 'package:superuser/utils.dart';
import 'package:superuser/widgets/image_view.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final controllers = Controllers.to;
  final admin = Firestore.instance.collection('admin');
  final utils = Utils();
  final controller = TextEditingController();
  final storage = FirebaseStorage.instance.ref().child('profile_pictures');

  @override
  void initState() {
    controller.text = controllers.userData.value.data['name'];
    controllers.shouldUpdateScreen.value = false;
    super.initState();
  }

  @override
  void dispose() {
    controllers.shouldUpdateScreen.value = true;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DataStreamBuilder<DocumentSnapshot>(
        stream: admin.document(controllers.firebaseUser.value.uid).snapshots(),
        builder: (context, snapshot) {
          print(controllers.firebaseUser.value.uid);
          void changeName() {
            Get.back();
            if (utils.validateInputText(controller.text)) {
              snapshot.reference
                  .updateData({'name': controller.text.toLowerCase()});
              utils.showSnackbar('Changes updated');
              controller.clear();
            } else {
              utils.showSnackbar('Given name is not valid');
            }
          }

          uploadImage(final PickedFile asset) async {
            try {
              storage
                  .child(snapshot.documentID)
                  .putData(await asset
                      .readAsBytes()
                      .then((value) => value.buffer.asUint8List()))
                  .onComplete
                  .then((value) {
                value.ref.getDownloadURL().then((value) async {
                  await snapshot.reference.updateData({'imageUrl': value});
                });
              });
            } catch (e) {
              utils.showSnackbar('Something went wrong');
            }
          }

          return Scaffold(
            appBar: utils.appbar('Profile'),
            body: utils.container(
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Get.to(
                          HariyalImageView(imageUrls: [snapshot['imageUrl']]));
                    },
                    child: Container(
                      padding: EdgeInsets.all(18),
                      margin: EdgeInsets.all(18),
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 90,
                          minRadius: 90,
                          backgroundImage: snapshot.data['imageUrl'] == null
                              ? AssetImage('assets/avatar-default-circle.png')
                              : CachedNetworkImageProvider(
                                  snapshot['imageUrl'],
                                ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: ListTile(
                      leading: Icon(
                        MdiIcons.accountOutline,
                        color: Colors.red,
                      ),
                      title: Text(
                        GetUtils.capitalize(snapshot['name']),
                        style: TextStyle(
                          color: Colors.red,
                          letterSpacing: 1,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.red),
                        onPressed: () => utils.getSimpleDialouge(
                          title: 'Change name',
                          content: utils.dialogInput(
                            controller: controller,
                            hintText: 'Type here',
                          ),
                          noPressed: () => Get.back(),
                          yesPressed: () => changeName(),
                        ),
                      ),
                    ),
                  ),
                  utils.listTile(
                    title: 'Change Profile Picture',
                    onTap: () => Get.bottomSheet(
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(9),
                            child: Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    MdiIcons.cameraOutline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final asset = await ImagePicker().getImage(
                                      source: ImageSource.camera,
                                      imageQuality: 75,
                                    );
                                    Get.back();
                                    if (asset != null) {
                                      utils.showSnackbar(
                                        'Changes will be displayed in a while',
                                      );
                                      uploadImage(asset);
                                    }
                                  },
                                ),
                                Text(
                                  'Camera',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9),
                            child: Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    MdiIcons.imageOutline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final asset = await ImagePicker().getImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 75,
                                    );
                                    Get.back();
                                    if (asset != null) {
                                      utils.showSnackbar(
                                        'Changes will be displayed in a while',
                                      );
                                      uploadImage(asset);
                                    }
                                  },
                                ),
                                Text(
                                  'Gallery',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(9),
                          topRight: Radius.circular(9),
                        ),
                      ),
                      enableDrag: true,
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                    ),
                  ),
                  utils.listTile(
                    title: 'Change Password',
                    onTap: () => Get.to(ChangePassword()),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
