import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/modules/list/views/list_view_view.dart';
import 'package:frappe_mobile_custom/app/modules/login/views/login_view.dart';
import 'package:frappe_mobile_custom/crm/modules/setting/setting_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../app/modules/list/bindings/list_view_binding.dart';
import '../../../app/modules/login/bindings/login_binding.dart';

class HomeController extends GetxController {
  List<Widget> screens = <Widget>[
    DocListView(docType: 'Sales Invoice'),
    DocListView(docType: 'Payment Entry',hiddenValues: const {'paid_amount':500},),
    DocListView(docType: 'Customer'),
    DocListView(docType: 'Lead'),
    const SettingView()
  ];
  var currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;
    update();
  }

}
