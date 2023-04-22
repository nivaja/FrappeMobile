import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_mobile_custom/app/api/api_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

void main() async{
  await GetStorage.init('Config');
  await initApiConfig();
  runApp(
    GetMaterialApp(
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
