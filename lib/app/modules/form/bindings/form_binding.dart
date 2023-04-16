import 'package:get/get.dart';

import '../controllers/form_controller.dart';

class FormBinding extends Bindings {
  String docType;
  String name;
  FormBinding({required this.docType,required this.name}):super();
  @override
  void dependencies() {
    Get.lazyPut<FormController>(
      () => FormController(docType: docType,name: name),
    );
  }
}
