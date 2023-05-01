import 'package:dio/dio.dart' as dio;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:frappe_mobile_custom/app/utils/form_helper.dart';
import 'package:get/get.dart';

import '../../../api/frappe_api.dart';
import '../../../generic/model/doc_type_response.dart';
import '../../../generic/model/upload_file_response.dart';

class NewFormController extends GetxController {
  final String docType;
  FormHelper formHelper;
  RxList<DoctypeField> fields = <DoctypeField>[].obs;
  var newDoc={}.obs;
  NewFormController({required this.docType, required this.formHelper});

  @override
  void onInit() async{
    await getFields();
    super.onInit();
  }

  Future getFields({CachePolicy cachePolicy=CachePolicy.forceCache}) async{
    var res = await FrappeAPI.getDoctype(docType,cachePolicy: cachePolicy);
    fields.value = res.docs[0].fields;
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

  Future<dio.Response> saveDoc() async {
    List<DoctypeField> list = fields.value.where((_) => (['Attach Image']
        .contains(_.fieldtype) && _.allowInQuickEntry == 1)).toList();
    for(var field in list ){
      var formState =formHelper.getKey().currentState!.fields[field.fieldname]!;
      if(formState.value != null) {
        //Upload Image First before saving doc and get image url
        UploadedFileResponse response = await FrappeAPI
            .uploadImage(
            doctype: docType, filePath: formState.value);
        formHelper
            .getKey()
            .currentState!
            .fields[field.fieldname]!.didChange(response.uploadedFile.fileUrl);
      }
    }
    return await FrappeAPI.saveDocs(docType,formHelper.getFormValue());
  }
}
