import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/superuser/categories.dart';
import 'package:superuser/widgets/image_view.dart';
import '../../utils.dart';
import '../shorooms.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<Asset> asset = [];
  StorageReference _storage =
      FirebaseStorage.instance.ref().child('profile_pictures');
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    final authorsnap = context.watch<DocumentSnapshot>();
    nameController.text = authorsnap.data['name'];
    return Scaffold(
      appBar: utils.appbar('Settings'),
      body: utils.container(
        child: ListView(
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Get.to(
                      HariyalImageView(
                        imageUrls: [authorsnap['imageUrl']],
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(18),
                    margin: EdgeInsets.all(18),
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        maxRadius: 90,
                        minRadius: 90,
                        backgroundImage: authorsnap['imageUrl'] == null
                            ? AssetImage('assets/avatar-default-circle.png')
                            : CachedNetworkImageProvider(
                                authorsnap['imageUrl']),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 18,
                  right: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      color: Colors.red,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(MdiIcons.accountEdit),
                      onPressed: () async {
                        if (await Permission.camera.request().isGranted &&
                            await Permission.storage.request().isGranted) {
                          asset = await MultiImagePicker.pickImages(
                            maxImages: 1,
                            enableCamera: false,
                            selectedAssets: asset,
                            materialOptions: MaterialOptions(
                              statusBarColor: '#FF6347',
                              startInAllView: true,
                              actionBarColor: "#FF6347",
                              actionBarTitle: "Pick Images",
                              allViewTitle: "Pick Images",
                              useDetailsView: false,
                              selectCircleStrokeColor: "#FF6347",
                            ),
                          );

                          if (asset != null) {
                            try {
                              _storage
                                  .child(authorsnap.documentID)
                                  .putData(await asset[0]
                                      .getByteData(quality: 75)
                                      .then((value) =>
                                          value.buffer.asUint8List()))
                                  .onComplete
                                  .then((value) {
                                value.ref.getDownloadURL().then((value) async {
                                  await authorsnap.reference
                                      .updateData({'imageUrl': value});
                                });
                              });
                            } catch (e) {
                              print(e);
                            }
                          }
                        } else {
                          utils.showSnackbar('Insufficient Permissions');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            utils.productInputText(
                label: 'User name', controller: nameController, readOnly: true),
            utils.listTile(
              title: 'Add Admin',
              leading: Icon(
                MdiIcons.humanChild,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(AddAdmin()),
            ),
            utils.listTile(
              title: 'Categories',
              leading: Icon(
                MdiIcons.cartArrowRight,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(
                CategoriesScreen(type: 'category'),
              ),
            ),
            utils.listTile(
              title: 'Locations',
              leading: Icon(
                MdiIcons.locationExit,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(
                CategoriesScreen(type: 'locations'),
              ),
            ),
            utils.listTile(
              title: 'Showrooms',
              leading: Icon(
                MdiIcons.mapMarkerOutline,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(Showrooms()),
            ),
          ],
        ),
      ),
    );
  }
}
