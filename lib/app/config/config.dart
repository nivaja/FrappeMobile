import 'package:frappe_mobile_custom/app/api/ApiService.dart';
import 'package:get_storage/get_storage.dart';
class Config {
  static final configContainer = GetStorage('Config');


  String? get userId =>
      Uri.decodeFull(configContainer.read('userId'));

  String get user => configContainer.read('user');

  String? get primaryCacheKey {
    if (baseUrl == null || userId == null) return null;
    return "$baseUrl$userId";
  }

  String get version => configContainer.read('version');

  String? get baseUrl => configContainer.read('baseUrl');

  Uri? get uri {
    if (baseUrl == null) return null;
    return Uri.parse(baseUrl!);
  }

  static Future set(String k, dynamic v) async {
    await configContainer.write(k, v);
  }
  static Map<String,dynamic>? get(String k) {
    return configContainer.read(k);
  }

  static Future clear() async {
    await configContainer.erase();
  }

  static Future remove(String k) async {
    await configContainer.remove(k);
  }

  Future setBaseUrl(url) async {
     await Config.set('baseUrl', url);
     await ApiService().init(url);
  }


}
