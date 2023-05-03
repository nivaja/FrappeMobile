import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/modules/list/views/list_view_view.dart';
import 'package:frappe_mobile_custom/app/modules/preferences/views/preferences_view.dart';
import 'package:get/get.dart';


class HomeController extends GetxController {
  List<Widget> screens = <Widget>[
    DocListView(docType: 'Sales Invoice'),
    DocListView(docType: 'Payment Entry',hiddenValues: const {'paid_amount':500},),
    DocListView(docType: 'Customer'),
    DocListView(docType: 'Lead'),
    ProfileView()
  ];
  var currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;
    update();
  }

}
