import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:frappe_mobile_custom/app/generic/common.dart';
import 'package:frappe_mobile_custom/app/utils/frappe_alert.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get.dart';
import '../../../api/frappe_api.dart';
import '../../../generic/model/doc_type_response.dart';
import '../../../generic/model/get_doc_response.dart';

class FormController extends GetxController {
  //TODO: Implement FormController
  late final String docType;
  late final String name;
  DoctypeResponse? docTypeDoc;
  var isDirty = false;
  bool isLoading = true;

  var fields = <DoctypeField>[];
  var doc = <String,dynamic>{};

  FormController({
    required this.name,
    required this.docType,
  });

  @override
  void onInit() async{

    await loadDoc();
    super.onInit();

  }

  Future loadDoc({CachePolicy cachePolicy=CachePolicy.forceCache}) async{
    docTypeDoc = await FrappeAPI.getDoctype(docType,cachePolicy: cachePolicy);
    fields = docTypeDoc!.docs[0].fields;
    GetDocResponse dr = await FrappeAPI.getDoc(docType,name);
    doc= dr.docs[0] as Map<String,dynamic>;
    isLoading=false;
    update([name]);
  }


  handleChange(){
    isDirty= true;
    update([name]);
  }

  Future updateDoc(Map data) async {
    await FrappeAPI.updateDocs(docType: docType, name: name, data: data);
    isDirty= false;
    update([name]);
    FrappeAlert.successAlert(title: '$docType Updated');
  }

  Future cancelDoc() async{
      doc = (await FrappeAPI.runDocMethod(docType, name, 'cancel'))['data'] as Map<String,dynamic>;
      update([name]);
      FrappeAlert.errorAlert(title: '$docType Cancelled');
  }

  Future submitDoc() async{
    doc = (await FrappeAPI.runDocMethod(docType, name, 'submit'))['data'] as Map<String,dynamic>;
    update([name]);
    FrappeAlert.successAlert(title: '$docType Submitted');
  }

}
