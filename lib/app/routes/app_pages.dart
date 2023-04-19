import 'package:frappe_mobile_custom/crm/modules/home/home_view.dart';
import 'package:get/get.dart';

import '../../crm/modules/home/home_binding.dart';
import '../config/config.dart';

import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static var INITIAL = (Config.get('isLoggedIn') != null && Config.get('isLoggedIn') as bool == true)?Routes.HOME:Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

  ];
}
