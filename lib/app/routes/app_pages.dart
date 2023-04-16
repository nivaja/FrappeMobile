import 'package:get/get.dart';

import '../config/config.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

import '../modules/list/bindings/list_view_binding.dart';
import '../modules/list/views/list_view_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static var INITIAL = (Config.get('isLoggedIn') != null && Config.get('isLoggedIn') as bool == true)?Routes.HOME:Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

  ];
}
