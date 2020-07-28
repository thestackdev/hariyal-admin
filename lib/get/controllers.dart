import 'package:get/get.dart';

class Controllers extends GetxController {
  RxInt currentScreen = 0.obs;
  void changeScreen(int) => currentScreen.value = int;
}
