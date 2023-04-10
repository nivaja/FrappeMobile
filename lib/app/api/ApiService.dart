
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

import 'api_interceptor.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  static Dio? dio;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    dio = Dio();
  }



  Future init(String baseUrl) async {
    // set up Dio instance with base URL, interceptors, etc.
    dio=Dio(
      BaseOptions(baseUrl: '$baseUrl/api')
    )..interceptors.addAll(
      [CookieManager(await _getCookiePath()),
        DioInterceptor()
      ]
              );
    dio?.options.connectTimeout = 60 * 1000;
    dio?.options.receiveTimeout = 60 * 1000;
  }

  Future<PersistCookieJar> _getCookiePath() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    return PersistCookieJar(
        ignoreExpires: true, storage: FileStorage("$appDocPath/.cookies/"));
  }

  // Future<String?> _getCookies() async {
  //   var cookieJar = await _getCookiePath();
  //   if (GetStorage('Config').read('baseUrl') != null) {
  //     var cookies = await cookieJar.loadForRequest(Uri.parse(GetStorage('Config').read('baseUrl')));
  //
  //     var cookie = CookieManager.getCookies(cookies);
  //
  //     return cookie;
  //   } else {
  //     return null;
  //   }
  // }

}