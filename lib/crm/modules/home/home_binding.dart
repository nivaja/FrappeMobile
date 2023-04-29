import 'package:frappe_mobile_custom/app/modules/list/views/list_view_view.dart';
import 'package:frappe_mobile_custom/crm/modules/home/home_controller.dart';
import 'package:get/get.dart';

import '../../../app/generic/connectivity_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(()=>ConnectivityController());
  }
}
