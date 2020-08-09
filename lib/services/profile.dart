import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/widgets/image_view.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final controllers = Controllers.to;
  final controller = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
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
    return controllers.utils.streamBuilder(
        stream: controllers.admin
            .document(controllers.firebaseUser.value.uid)
            .snapshots(),
        builder: (context, snapshot) {
          controller.text = GetUtils.capitalizeFirst(snapshot.data['name']);
          void changeName() {
            if (controllers.utils.validateInputText(controller.text)) {
              snapshot.reference
                  .updateData({'name': controller.text.toLowerCase()});
              controllers.utils.snackbar('Changes updated');
            } else {
              controllers.utils.snackbar('Given name is not valid');
            }
          }

          uploadImage(PickedFile asset) async {
            try {
              controllers.firebaseStorage
                  .ref()
                  .child('profile_pictures')
                  .child(snapshot.documentID)
                  .putData(await asset
                      .readAsBytes()
                      .then((assetByte) => assetByte.buffer.asUint8List()))
                  .onComplete
                  .then((value) {
                value.ref.getDownloadURL().then((value) async {
                  await snapshot.reference.updateData({'imageUrl': value});
                });
              });
            } catch (e) {
              controllers.utils.snackbar('Something went wrong');
            }
          }

          return controllers.utils.root(
            label: 'Profile',
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (snapshot.data['imageUrl'] != null) {
                      Get.to(
                          HariyalImageView(imageUrls: [snapshot['imageUrl']]));
                    }
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
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: TextFormField(
                    readOnly: !isEditing,
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'User name',
                      labelStyle:
                          Get.textTheme.headline3.apply(fontSizeFactor: 1.1),
                      suffixIcon: IconButton(
                        icon: Icon(isEditing ? OMIcons.check : OMIcons.edit),
                        onPressed: () => {
                          if (isEditing) changeName(),
                          isEditing = !isEditing,
                          handleState(),
                        },
                      ),
                    ),
                  ),
                ),
                controllers.utils.listTile(
                  title: 'Change Profile Picture',
                  onTap: () => Get.bottomSheet(
                    Container(
                        height: 90,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                OMIcons.camera,
                                size: 36,
                                color: Colors.redAccent,
                              ),
                              onPressed: () async {
                                final asset = await ImagePicker().getImage(
                                  source: ImageSource.camera,
                                  imageQuality: 75,
                                );
                                Get.back();
                                if (asset != null) {
                                  controllers.utils.snackbar(
                                    'Changes will be displayed in a while',
                                  );
                                  uploadImage(asset);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                OMIcons.image,
                                size: 36,
                                color: Colors.redAccent,
                              ),
                              onPressed: () async {
                                final asset = await ImagePicker().getImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 75,
                                );
                                Get.back();
                                if (asset != null) {
                                  controllers.utils.snackbar(
                                    'Changes will be displayed in a while',
                                  );
                                  uploadImage(asset);
                                }
                              },
                            )
                          ],
                        )),
                    backgroundColor: Colors.white,
                  ),
                ),
                controllers.utils.listTile(
                  title: 'Change Password',
                  onTap: () => Get.toNamed('changePassword'),
                ),
              ],
            ),
          );
        });
  }

  handleState() => mounted ? setState(() => null) : null;
}
