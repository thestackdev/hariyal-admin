import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'widgets/network_image.dart';

class FullScreen extends StatelessWidget {
  final image, tag;
  final String imageLink;

  FullScreen({this.image, this.tag, this.imageLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  padding: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  color: Colors.white,
                  minWidth: 0,
                  height: 40,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.center,
                child: Hero(
                    tag: tag,
                    child: imageLink == null
                        ? Image.file(
                            image,
                            width: 270,
                            height: 270,
                            errorBuilder: (context, url, error) =>
                                Icon(Icons.error_outline),
                            filterQuality: FilterQuality.medium,
                          )
                        : PNetworkImage(
                            imageLink,
                            fit: BoxFit.contain,
                            width: 270,
                            height: 270,
                          )),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black45,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          back(context,
                              image: image != null ? image : imageLink,
                              isDeleted: true);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        onTap: () async {
                          File croppedFile = await ImageCropper.cropImage(
                            sourcePath: image.path,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                              CropAspectRatioPreset.ratio3x2,
                              CropAspectRatioPreset.original,
                              CropAspectRatioPreset.ratio4x3,
                              CropAspectRatioPreset.ratio16x9
                            ],
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Crop Image',
                                toolbarColor: Theme.of(context).accentColor,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                          );
                          if (croppedFile == null) return;
                          back(context, image: croppedFile, isDeleted: false);
                        },
                        leading: Icon(
                          Icons.crop,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Crop',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void back(BuildContext context, {isDeleted, image}) {
    Navigator.pop(
        context, {'isDeleted': isDeleted, 'index': tag, 'image': image});
  }
}
