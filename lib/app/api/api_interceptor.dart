import 'dart:convert';

import 'package:dio/dio.dart';

class DioInterceptor extends InterceptorsWrapper{
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(err.stackTrace.toString());
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("Resquest --> ${ jsonEncode(options.data)}");
    print("Resquest Params --> ${ jsonEncode(options.queryParameters.toString())}");
    super.onRequest(options,handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("Response --> ${response.data.toString()}");

    super.onResponse(response, handler);
  }


}