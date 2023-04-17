import 'package:dio/dio.dart' as dio;
import 'package:frappe_mobile_custom/app/modules/form/bindings/form_binding.dart';
import 'package:frappe_mobile_custom/app/modules/form/views/form_view.dart';
import 'package:get/get.dart';

import '../../../api/frappe_api.dart';
import '../../../generic/model/doc_type_response.dart';

class NewFormController extends GetxController {
  //TODO: Implement NewFormController
  final String docType;
  RxList<DoctypeField> fields = <DoctypeField>[].obs;
  var newDoc={}.obs;
  NewFormController({required this.docType});

  @override
  void onInit() async{
    await getFields();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

  }

  @override
  void onClose() {
    super.onClose();
  }

  Future getFields() async{

    var res = await FrappeAPI.getDoctype(docType);
    fields.value = res.docs[0].fields.where((field) => field.allowInQuickEntry ==1).toList();
    fields.forEach((field) {
      var defaultVal = field.defaultValue;

      if (field.fieldtype == "Table") {
        defaultVal = [];
      }
      newDoc.value[field.fieldname] = defaultVal;
    });
    fields.refresh();
    update([docType]);
  }

  Future<dio.Response> saveDoc(Map data) async {
    dio.Response res = await FrappeAPI.saveDocs(docType,data) ;
    return res;

  }
}
