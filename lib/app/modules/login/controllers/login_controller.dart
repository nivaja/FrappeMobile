import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:frappe_mobile_custom/app/api/ApiService.dart';
import 'package:frappe_mobile_custom/app/api/api_helper.dart';
import 'package:frappe_mobile_custom/app/generic/common.dart';
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

    try {
      await setBaseUrl(loginRequest['url'] as String);
            dio.Response response = await ApiService.dio!.post(
          "/method/login", data: loginRequest);
      await Config.set('loginRequest', loginRequest);

      if (response.statusCode == HttpStatus.ok) {
        Config.set('isLoggedIn', true);
        await ApiService.initCookies();
        Get.to(() => HomeView());
      } else {
        throw ErrorResponse(
          statusMessage: response.data["message"],
          statusCode: response.statusCode,
        );
      }
    // }
    // on DioError catch (e) {
    //   AwesomeDialog(
    //       context: Get.context!,
    //       title:'Error1',
    //       desc: e.message,
    //       dialogType: DialogType.error
    //   ).show();
    }catch(e){
      Config.set('isLoggedIn', true);
      if (e is! DioError) rethrow;

      final error = e.error;
      if (error is SocketException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: error.message,
        );
      }

      if (error is HandshakeException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: "Cannot connect securely to server."
              " Please ensure that the server has a valid SSL configuration.",
        );
      }

      rethrow;
    }





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
