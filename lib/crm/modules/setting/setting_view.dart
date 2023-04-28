import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/api/frappe_api.dart';
import 'package:frappe_mobile_custom/app/modules/login/views/login_view.dart';
import 'package:frappe_mobile_custom/app/utils/enums.dart';
import 'package:frappe_mobile_custom/app/widget/frappe_button.dart';
import 'package:get/get.dart';

import '../../../app/config/config.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FrappeFlatButton(
        title: 'Logout',
        buttonType: ButtonType.danger,
        onPressed: ()async{
          await FrappeAPI.logout();
          Config.set('isLoggedIn', false);
          Get.offAll(()=>LoginView());
        },
      ),
    );
  }
}
