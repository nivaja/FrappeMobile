import 'package:frappe_mobile_custom/app/api/ApiService.dart';

import '../config/config.dart';

Future<void> setBaseUrl(url) async {
  await Config.set('baseUrl', url);
  await ApiService().init(url);
}

initApiConfig() async {
  if (Config().baseUrl != null) {
    await ApiService().init(Config().baseUrl!);
    await ApiService.initCookies();
  }
}