import 'package:get/get.dart';

import '../../../api/frappe_api.dart';
import '../../../generic/model/doc_type_response.dart';
import '../../../generic/model/get_doc_response.dart';

class FormController extends GetxController {
  //TODO: Implement FormController
  late final String docType;
  late final String name;
  var isDirty = false;

  var fields = <DoctypeField>[];
  var doc = <String,dynamic>{};

  FormController({
    required this.name,
    required this.docType
  });

  @override
  void onInit() async{
    await loadDoc();

    super.onInit();

  }



  Future loadDoc() async{
    DoctypeResponse dt = await FrappeAPI.getDoctype(docType);
    fields = dt.docs[0].fields.where((field) => field.allowInQuickEntry ==1 ).toList();
    GetDocResponse dr = await FrappeAPI.getDoc(docType,name);
    doc= dr.docs[0] as Map<String,dynamic>;

    update([name]);
  }
  Future saveDoc(Map data) async {
    await FrappeAPI.saveDocs(docType,data);
    isDirty= false;
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
  }


}
