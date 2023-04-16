import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../generic/common.dart';
import '../utils/utils.dart';

class DioInterceptor extends InterceptorsWrapper{
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
      if (err.response != null &&
          err.response!.data != null &&
          err.response!.data["_server_messages"] != null) {
        var errorMsg = getServerMessage(err.response!.data["_server_messages"]);
        getx.Get.defaultDialog(title: 'Error1',middleText:errorMsg,);
        throw ErrorResponse(
          statusCode: err.response!.statusCode,
          statusMessage: errorMsg,
        );
      } else {
        if (err.error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: err.error.message,
          );
        } else {
          AwesomeDialog(
            context: navigator!.context,
            title: 'Error',
            desc: err.response?.statusMessage??'',
            dialogType: DialogType.error,
          ).show();
          throw ErrorResponse(
            statusCode: err.response?.statusCode,
            statusMessage: err.response?.statusMessage,
          );
        }
      }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("Resquest -->${options.method} ${options.uri} ${jsonEncode(options.data)}");
    print("Resquest Params --> ${ jsonEncode(options.queryParameters.toString())}");

    super.onRequest(options,handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("Response --> ${response.data.toString()}");

    super.onResponse(response, handler);
  }


}