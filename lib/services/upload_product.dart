import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superuser/get/controllers.dart';

class PushProduct {
  final controllers = Controllers.to;
  List imageUrls = [];

  uploadProduct(
      {List<File> images,
      String category,
      String subCategory,
      String state,
      String area,
      String adressID,
      double price,
      String title,
      String description,
      Map specifications,
      String uid,
      bool authored,
      List<String> searchList}) async {
    imageUrls.clear();
    await Future.forEach(images, (element) async {
      imageUrls.add(await uploadProductImages(element));
    });

    await controllers.products.document().setData({
      'title': title,
      'description': description,
      'images': imageUrls,
      'location': {'state': state, 'area': area},
      'category': {'category': category, 'subCategory': subCategory},
      'author': uid,
      'address': adressID,
      'price': price,
      'specifications': specifications,
      'isSold': false,
      'soldTo': null,
      'soldReason': null,
      'interested_count': 0,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
      'authored': authored,
      'isDeleted': false,
      'sold_timestamp': null,
      'rejected': false,
      'reject_reason': null,
      'searchList': searchList
    });
  }

  updateProduct({
    List newImages,
    docID,
    List oldImages,
    category,
    state,
    area,
    price,
    title,
    description,
    adressID,
    subCategory,
    specifications,
    List<String> searchList
  }) async {
    imageUrls.clear();
    if (oldImages == null || oldImages.length <= 0) {
      await Future.forEach(newImages, (element) async {
        imageUrls.add(await uploadProductImages(element));
      });
    } else {
      imageUrls = oldImages;
      if (newImages != null && newImages.length > 0) {
        await Future.forEach(newImages, (element) async {
          imageUrls.add(await uploadProductImages(element));
        });
      }
    }

    await controllers.products.document(docID).updateData(
        {'searchList': FieldValue.delete()});

    await controllers.products.document(docID).updateData({
      'title': title,
      'description': description,
      'images': imageUrls,
      'location': {'state': state, 'area': area},
      'category': {'category': category, 'subCategory': subCategory},
      'adress': adressID,
      'price': price,
      'specifications': specifications,
      'searchList': searchList
    });
  }

  Future<String> uploadProductImages(File images) async {
    try {
      return controllers.firebaseStorage
          .ref()
          .child('products')
          .child(DateTime.now().microsecondsSinceEpoch.toString())
          .putFile(images)
          .onComplete
          .then((value) {
        return value.ref.getDownloadURL().then((value) {
          return value.toString();
        });
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
