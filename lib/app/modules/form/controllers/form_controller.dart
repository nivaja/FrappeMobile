import 'package:get/get.dart';

import '../../../api/frappe_api.dart';
import '../../../generic/model/doc_type_response.dart';
import '../../../generic/model/get_doc_response.dart';

class FormController extends GetxController {
  //TODO: Implement FormController
  late final String docType;
  late final String name;
  var isDirty = false.obs;

  var fields = <DoctypeField>[].obs;
  var doc = Map<String,dynamic>().obs;

  FormController({
    required this.name,
    required this.docType
  });

  @override
  void onInit() async{
    await loadDoc(docType: docType, name: name);
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

  Future loadDoc({required String docType, required String name}) async{
    DoctypeResponse dt = await FrappeAPI.getDoctype(docType);
    fields.value = dt.docs[0].fields.where((field) => field.allowInQuickEntry ==1 ).toList();
    GetDocResponse dr = await FrappeAPI.getDoc(docType,name);
    doc.value = dr.docs[0] as Map<String,dynamic>;
    fields.refresh();
    doc.refresh();
    update();
  }
  Future saveDoc(Map data) async {
    await FrappeAPI.saveDocs(docType,data);
    isDirty.value = false;
    update();
  }

  handleChange(){
    isDirty.value = true;
    update();
  }

  Future updateDoc(Map data) async {
    await FrappeAPI.updateDocs(docType: docType, name: name, data: data);
    isDirty.value = false;
    update();
  }
}
