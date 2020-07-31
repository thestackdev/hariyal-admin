import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PushProduct {
  List imageUrls = [];
  final _storage = FirebaseStorage.instance.ref().child('products');
  CollectionReference _reference = Firestore.instance.collection('products');

  uploadProduct({
    List<File> images,
    category,
    subCategory,
    state,
    area,
    adressID,
    price,
    title,
    description,
    specifications,
    uid,
  }) async {
    imageUrls.clear();
    await Future.forEach(images, (element) async {
      imageUrls.add(await uploadProductImages(element));
    });

    await _reference.document().setData({
      'title': title,
      'description': description,
      'images': imageUrls,
      'location': {'state': state, 'area': area},
      'category': {'category': category, 'subCategory': subCategory},
      'author': uid,
      'adress': adressID,
      'price': price,
      'specifications': specifications,
      'isSold': false,
      'soldTo': null,
      'soldReason': null,
      'interested_count': 0,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
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

    await _reference.document(docID).updateData({
      'title': title,
      'description': description,
      'images': imageUrls,
      'location': {'state': state, 'area': area},
      'category': {'category': category, 'subCategory': subCategory},
      'adress': adressID,
      'price': price,
      'specifications': specifications,
    });
  }

  Future<String> uploadProductImages(File images) async {
    try {
      return _storage
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
