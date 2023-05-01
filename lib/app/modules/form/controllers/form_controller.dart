
import 'package:frappe_mobile_custom/app/utils/frappe_alert.dart';
import 'package:get/get.dart';
import '../../../api/frappe_api.dart';
import '../../../generic/model/doc_type_response.dart';
import '../../../generic/model/get_doc_response.dart';

class FormController extends GetxController {
  //TODO: Implement FormController
  late final String docType;
  late final String name;
  DoctypeResponse? docTypeDoc;
  Docinfo? docInfo;
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
    await getDocInfo();
    super.onInit();

  }

  Future getDocInfo()async{
    isLoading = true;
    docInfo=await FrappeAPI.getDocinfo(docType,name);
    isLoading = false;
    update([name]);
  }
  Future loadDoc() async{
    docTypeDoc = await FrappeAPI.getDoctype(docType);
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
