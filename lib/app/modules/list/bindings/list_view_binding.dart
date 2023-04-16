import 'package:flutter/foundation.dart';
import 'package:frappe_mobile_custom/app/generic/connectivity_controller.dart';
import 'package:get/get.dart';

import '../controllers/list_view_controller.dart';

class ListViewBinding extends Bindings {
  String docType;
  ListViewBinding({required this.docType}):super();
  @override
  void dependencies() {
    Get.lazyPut<ConnectivityController>(() => ConnectivityController());
    Get.lazyPut<DocTypeListViewController>(
      () => DocTypeListViewController(docType: docType),
    );
  }
}
