import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Controllers extends GetxController {
  static Controllers to = Get.find<Controllers>();

  RxInt currentScreen = 0.obs;
  RxString uid = RxString();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference reference = Firestore.instance.collection('extras');
  final CollectionReference userRef = Firestore.instance.collection('admin');

  Rx<FirebaseUser> firebaseUser = Rx<FirebaseUser>();
  Rx<DocumentSnapshot> categories = Rx<DocumentSnapshot>();
  Rx<DocumentSnapshot> locations = Rx<DocumentSnapshot>();
  Rx<DocumentSnapshot> specifications = Rx<DocumentSnapshot>();
  Rx<DocumentSnapshot> userData = Rx<DocumentSnapshot>();

  void changeScreen(int num) => currentScreen.value = num;

  @override
  void onInit() {
    ever(firebaseUser, handleAuth);

    firebaseUser.bindStream(firebaseAuth.onAuthStateChanged);

    reference.snapshots().obs.value.listen((event) {
      event.documents.forEach((element) {
        if (element.documentID == 'category') {
          categories.value = element;
        } else if (element.documentID == 'locations') {
          locations.value = element;
        } else if (element.documentID == 'specifications') {
          specifications.value = element;
        }
      });
    });

    super.onInit();
  }

  handleAuth(firebaseUser) {
    if (firebaseUser == null) {
      Get.offAllNamed('/authenticate');
    } else {
      uid.value = firebaseUser.uid;
      userRef.document(firebaseUser.uid).obs.value.snapshots().listen((event) {
        userData.value = event;
        if (event.data['isSuperuser']) {
          Get.offAllNamed('/superuser_home');
        } else if (event.data['isAdmin']) {
          Get.offAllNamed('/admin_home');
        } else {
          firebaseAuth.signOut();
        }
      });
    }
  }
}
