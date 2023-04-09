import 'package:dio/dio.dart' as dio;
import 'package:frappe_mobile_custom/app/api/ApiService.dart';
import 'package:frappe_mobile_custom/app/modules/home/views/home_view.dart';
import 'package:get/get.dart';

import '../../../config/config.dart';

class LoginController extends GetxController {
  var loginRequest = RxMap<String,dynamic>();

  @override
  void onInit() {
    // TODO: implement onInit
    getSavedUser();
    super.onInit();
  }

  //TODO: Implement LoginController
  void login(Map<String,dynamic> loginRequest) async{
    ApiService().init(loginRequest['url'] as String);
    dio.Response response = await ApiService.dio!.post("/method/login",data:loginRequest);
    await Config.set('loginRequest', loginRequest);
    print(response.data);
    Get.to(()=>HomeView());
  }
  void getSavedUser() {
    try{
      var savedCreds  = Config.get('loginRequest');
      if ( savedCreds != null){
        loginRequest.value = savedCreds as Map<String,dynamic> ;
      }
    }catch(error){
      print(error.toString());
    }

  }

}
