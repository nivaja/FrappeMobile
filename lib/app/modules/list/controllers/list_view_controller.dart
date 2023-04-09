import 'package:get/get.dart';

import '../../../api/frappe_api.dart';

class DocTypeListViewController extends GetxController {
  //TODO: Implement ListViewController

  var docList = [].obs;
  @override
  void onInit() {

    super.onInit();
  }
  Future getList(String docType) async{
    var list = await FrappeAPI.fetchList(
        doctype: docType,
        fieldnames: ['*'],
    );
    docList.addAll(list);
  }

}
