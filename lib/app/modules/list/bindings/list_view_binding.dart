import 'package:get/get.dart';

import '../controllers/list_view_controller.dart';

class ListViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocTypeListViewController>(
      () => DocTypeListViewController(),
    );
  }
}
