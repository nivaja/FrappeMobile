import 'package:frappe_mobile_custom/app/api/frappe_api.dart';
import 'package:frappe_mobile_custom/app/generic/model/doc_type_response.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:frappe_mobile_custom/app/api/ApiService.dart';

import '../../../generic/model/get_doc_response.dart';
class HomeController extends GetxController {
  //TODO: Implement HomeController
  var fields = RxList<DoctypeField>();
  var doc = RxMap<String,dynamic>();
  @override
  void onInit() async{
    getFields();
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

  getFields() async{
    DoctypeResponse dt = await FrappeAPI.getDoctype('POS Invoice');
    fields.value = dt.docs[0].fields.where((field) => field.reqd==1 || field.allowInQuickEntry ==1 ).toList();
    GetDocResponse dr = await FrappeAPI.getDoc('POS Invoice','ACC-PSINV-2023-00001');
    doc.value = dr.docs[0] as Map<String,dynamic>;
    print("\ndoc value ---> \n  ${doc.value.runtimeType} \n ");

    // dio.Response sales = await ApiService.dio!.get("/api/method/frappe.desk.form.load.getdoc",queryParameters:{
    //   "doctype": "Sales Trip",
    //   "name":"ST-04-04-23-All Territories-Sales Team"
    // });
    // print(sales.data);
  }
}
