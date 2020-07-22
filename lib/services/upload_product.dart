import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PushProduct {
  List imageUrls = [];
  final _storage = FirebaseStorage.instance.ref().child('products');
  Firestore _reference = Firestore.instance;

  uploadProduct({
    List<Asset> images,
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

    final docID = DateTime.now().microsecondsSinceEpoch.toString();

    await _reference.collection('products').document(docID).setData({
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
    });
    await _reference
        .collection('admin')
        .document(uid)
        .collection('products')
        .document(docID)
        .setData({
      'dateTime': docID,
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

    await _reference.collection('products').document(docID).updateData({
      'title': title,
      'description': description,
      'images': imageUrls,
      'location': {
        'state': state.toLowerCase(),
        'area': area.toLowerCase(),
      },
      'category': {'category': category, 'subCategory': subCategory},
      'adress': adressID,
      'price': price,
      'specifications': specifications,
    });
  }

  uploadProductImages(Asset images) async {
    try {
      return _storage
          .child(DateTime
          .now()
          .microsecondsSinceEpoch
          .toString())
          .putData(await images
          .getByteData(quality: 75)
          .then((value) => value.buffer.asUint8List()))
          .onComplete
          .then((value) {
        return value.ref.getDownloadURL();
      });
    } catch (e) {
      return null;
    }
  }
}
