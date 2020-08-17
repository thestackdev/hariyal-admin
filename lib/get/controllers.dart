import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../utils.dart';

class Controllers extends GetxController {
  static Controllers to = Get.find();

  RxBool shouldUpdateScreen = true.obs;
  RxBool isSuperuser = false.obs;

  final firebaseAuth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  final utils = Utils();

  CollectionReference extras;
  CollectionReference admin;
  CollectionReference products;
  CollectionReference interests;
  CollectionReference customers;
  CollectionReference showrooms;
  CollectionReference orders;
  CollectionReference reports;

  Stream<DocumentSnapshot> categoryStream;
  Stream<DocumentSnapshot> locationsStream;
  Stream<DocumentSnapshot> specificationsStream;

  Rx<FirebaseUser> firebaseUser = Rx<FirebaseUser>();
  Rx<DocumentSnapshot> userData = Rx<DocumentSnapshot>();

  @override
  void onInit() {
    ever(firebaseUser, handleAuth);

    firebaseUser.bindStream(firebaseAuth.onAuthStateChanged);

    extras = firestore.collection('extras');
    admin = firestore.collection('admin');
    products = firestore.collection('products');
    interests = firestore.collection('interests');
    customers = firestore.collection('customers');
    showrooms = firestore.collection('showrooms');
    orders = firestore.collection('orders');
    reports = firestore.collection('reports');

    super.onInit();
  }

  handleAuth(firebaseUser) {
    if (firebaseUser == null) {
      Get.offAllNamed('authenticate');
    } else {
      categoryStream = extras.document('category').snapshots();
      locationsStream = extras.document('locations').snapshots();
      specificationsStream = extras.document('specifications').snapshots();

      admin.document(firebaseUser.uid).obs.value.snapshots().listen((event) {
        userData.value = event;

        if (shouldUpdateScreen.value) {
          if (event.data['isSuperuser']) {
            isSuperuser.value = true;
            Get.offAllNamed('superuser_home');
          } else if (event.data['isAdmin']) {
            isSuperuser.value = false;
            Get.offAllNamed('admin_home');
          } else {
            firebaseAuth.signOut();
          }
        }
      });
    }
  }
}
