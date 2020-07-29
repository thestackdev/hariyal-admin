import 'package:get/get.dart';
import 'package:superuser/admin/admin_home.dart';
import 'package:superuser/admin_extras/customer_details.dart';
import 'package:superuser/authenticate.dart';
import 'package:superuser/initial_page.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/services/profile.dart';
import 'package:superuser/superuser/interests.dart';
import 'package:superuser/superuser/superuser_home.dart';
import 'package:superuser/superuser/superuser_screens/more.dart';

class Pages {
  static final routes = [
    GetPage(
      name: '/initialPage',
      page: () => InitialRoute(),
    ),
    GetPage(
      name: '/authenticate',
      page: () => Authenticate(),
    ),
    GetPage(
      name: '/superuser_home',
      page: () => SuperuserHome(),
    ),
    GetPage(
      name: '/admin_home',
      page: () => AdminHome(),
    ),
    GetPage(
      name: '/settings',
      page: () => Settings(),
    ),
    GetPage(
      name: '/profile',
      page: () => Profile(),
    ),
    GetPage(
      name: '/add_admin',
      page: () => AddAdmin(),
    ),
    GetPage(
      name: '/interests',
      page: () => Interests(),
    ),
    GetPage(
      name: '/customer_deatils',
      page: () => Customerdetails(),
    ),
  ];
}
