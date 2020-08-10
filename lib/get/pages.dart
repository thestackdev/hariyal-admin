import 'package:get/get.dart';
import 'package:superuser/admin/admin_home.dart';
import 'package:superuser/admin_extras/admin_tabs.dart';
import 'package:superuser/admin_extras/customer_details.dart';
import 'package:superuser/authenticate.dart';
import 'package:superuser/initial_page.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/services/all_products.dart';
import 'package:superuser/services/change_password.dart';
import 'package:superuser/services/product_details.dart';
import 'package:superuser/services/profile.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/services/search_page.dart';
import 'package:superuser/services/showroom_details.dart';
import 'package:superuser/superuser/interests.dart';
import 'package:superuser/superuser/superuser_home.dart';
import 'package:superuser/superuser/superuser_screens/admins.dart';
import 'package:superuser/superuser/superuser_screens/customers.dart';
import 'package:superuser/superuser/superuser_screens/more.dart';
import 'package:superuser/superuser/utilities/add_showroom.dart';
import 'package:superuser/superuser/utilities/categories.dart';
import 'package:superuser/superuser/utilities/showrooms.dart';
import 'package:superuser/superuser/utilities/specificationData.dart';
import 'package:superuser/superuser/utilities/specifications.dart';
import 'package:superuser/superuser/utilities/states.dart';

import '../services/forgot_password.dart';

class Pages {
  static final routes = [
    GetPage(
      name: '/initialPage',
      page: () => InitialRoute(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/search',
      page: () => SearchPage(),
      transition: Transition.noTransition,
    ),
    GetPage(name: '/authenticate', page: () => Authenticate()),
    GetPage(name: '/superuser_home', page: () => SuperuserHome()),
    GetPage(name: '/admin_home', page: () => AdminHome()),
    GetPage(name: '/settings', page: () => Settings()),
    GetPage(name: '/profile', page: () => Profile()),
    GetPage(name: '/add_admin', page: () => AddAdmin()),
    GetPage(name: '/interests', page: () => Interests()),
    GetPage(name: '/customer_deatils', page: () => Customerdetails()),
    GetPage(name: '/categories', page: () => CategoriesScreen()),
    GetPage(name: '/specifications', page: () => Specifications()),
    GetPage(name: '/states', page: () => States()),
    GetPage(name: '/showrooms', page: () => Showrooms()),
    GetPage(name: '/all_products', page: () => AllProducts()),
    GetPage(name: '/all_customers', page: () => AllCustomers()),
    GetPage(name: '/admins', page: () => Admins()),
    GetPage(name: '/add_showroom', page: () => AddShowroom()),
    GetPage(name: '/product_details', page: () => ProductDetails()),
    GetPage(name: '/admin_extras', page: () => AdminExtras()),
    GetPage(name: '/add_showroom', page: () => AddShowroom()),
    GetPage(name: '/showroom_details', page: () => ShowroomDetails()),
    GetPage(name: '/specifications_data', page: () => SpecificationData()),
    GetPage(name: 'add_product', page: () => PushData()),
    GetPage(name: 'forgotPassword', page: () => ForgotPassword()),
    GetPage(name: 'changePassword', page: () => ChangePassword()),
  ];
}
