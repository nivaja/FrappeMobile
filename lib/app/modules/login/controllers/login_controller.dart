import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frappe_mobile_custom/app/api/ApiService.dart';
import 'package:frappe_mobile_custom/app/api/api_helper.dart';
import 'package:frappe_mobile_custom/app/generic/common.dart';
import 'package:frappe_mobile_custom/crm/modules/home/home_binding.dart';
import 'package:frappe_mobile_custom/crm/modules/home/home_view.dart';
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
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: const CircularProgressIndicator(backgroundColor: Colors.white),
        status: 'Please Wait...',);
      await setBaseUrl(loginRequest['url'] as String);
      dio.Response response = await ApiService.dio!.post(
          "/method/login", data: loginRequest);
      await Config.set('loginRequest', loginRequest);
      if (response.statusCode == HttpStatus.ok) {
        Config.set('isLoggedIn', true);
        Config.set('user',loginRequest['usr']);
        Config.set('username',response.data['full_name']);
        await ApiService.initCookies();
        Get.offAll(()=>HomePage(),binding: HomeBinding());
      } else {
        throw ErrorResponse(
          statusMessage: response.data["message"],
          statusCode: response.statusCode,
        );
      }
    }catch(e){
      Config.set('isLoggedIn', false);
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
    }finally{
      EasyLoading.dismiss();
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
