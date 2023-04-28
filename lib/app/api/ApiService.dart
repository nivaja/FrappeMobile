
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../config/config.dart';
import 'api_interceptor.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  static Dio? dio;
  static String? cookies;
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
        [
          CookieManager(await getCookiePath()),
          DioInterceptor(),
          DioCacheInterceptor(options: CacheOptions(
              maxStale: const Duration(days: 7),
              store:HiveCacheStore(await getTempDir()),
              policy: CachePolicy.refreshForceCache,
              hitCacheOnErrorExcept: []
            )
          )
        ]
    );
    dio?.options.connectTimeout = 60 * 1000;
    dio?.options.receiveTimeout = 60 * 1000;

  }

  static Future<PersistCookieJar> getCookiePath() async {
    return PersistCookieJar(
        ignoreExpires: true, storage: FileStorage("${await getAppDir()}/.cookies/"));
  }
  static Future<String> getAppDir() async{
    Directory appDocDir = await getApplicationSupportDirectory();
    return appDocDir.path;
  }
  Future<String> getTempDir() async{
    Directory appDocDir = await getTemporaryDirectory();
    return appDocDir.path;
  }
  static Future initCookies() async {
    cookies = await getCookies();
  }

  static Future<String?> getCookies() async {
    var cookieJar = await getCookiePath();
    if (Config().uri != null) {
      var cookies = await cookieJar.loadForRequest(Config().uri!);
      var cookie = CookieManager.getCookies(cookies);
      return cookie;
    } else {
      return null;
    }
  }
}