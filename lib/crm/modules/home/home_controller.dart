import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/modules/list/views/list_view_view.dart';
import 'package:frappe_mobile_custom/app/modules/login/views/login_view.dart';
import 'package:get/get.dart';

import '../../../app/modules/list/bindings/list_view_binding.dart';
import '../../../app/modules/login/bindings/login_binding.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  var currentIndex = 0.obs;

  final pages = <String>['/pos-invoice', '/payment', '/customer','/login'];

  void changePage(int index) {
    currentIndex.value = index;
    Get.offAndToNamed(pages[index], id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/pos-invoice') {
      String docType ='Sales Invoice';
      return GetPageRoute(
        settings: settings,
        page: () => DocListView(docType: docType,hiddenValues: {'latitude':'1235'}),
        binding: ListViewBinding(docType: docType),
      );
    }

    if (settings.name == '/payment') {
      String docType ='Payment Entry';
      return GetPageRoute(
        settings: settings,
        page: () => DocListView(docType: docType,hiddenValues: const {'paid_amount':'500','latitude':'1235'},),
        binding: ListViewBinding(docType: docType),
      );
    }

    if (settings.name == '/customer') {
      String docType ='Customer';
      return GetPageRoute(
        settings: settings,
        page: () => DocListView(docType: docType),
        binding: ListViewBinding(docType: docType),
      );
    }
    if (settings.name == '/login') {
      return GetPageRoute(
        settings: settings,
        page: () => LoginView(),
        binding: LoginBinding(),
      );
    }

    return null;
  }
}
