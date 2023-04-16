
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/frappe_icons.dart';
import '../config/frappe_palette.dart';
import 'frappe_icon.dart';

class FrappeAlert{
  static showAlert({
    required String icon,
    required String title,
    required MaterialColor color,
    String? subtitle,
    Duration alertDuration = const Duration(seconds: 3),
}){

  Get.showSnackbar(
      GetSnackBar(
        messageText: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: color[100],
          ),
          child: ListTile(
            title: Row(
              children: [
                FrappeIcon(
                  icon,
                  color: color,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: subtitle != null
                ? Row(
              children: [
                const SizedBox(
                  width: 36.0,
                ),
                Flexible(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: color[600],
                    ),
                  ),
                )
              ],
            )
                : null,
          ),
        ),
        duration:  alertDuration,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 500),

      )
  );


  }

  static infoAlert({
    required String title,
   
    String? subtitle,
  }) {
    FrappeAlert.showAlert(
      icon: FrappeIcons.info,
      title: title,
      
      color: FrappePalette.blue,
      subtitle: subtitle,
    );
  }

  static warnAlert({
    required String title,
   
    String? subtitle,
  }) {
     FrappeAlert.showAlert(
      icon: FrappeIcons.warning,
      title: title,
      
      color: FrappePalette.yellow,
      subtitle: subtitle,
    );
  }

  static errorAlert({
    required String title,
   
    String? subtitle,
  }) {
    FrappeAlert.showAlert(
      icon: FrappeIcons.error,
      title: title,
      
      color: FrappePalette.red,
      subtitle: subtitle,
    );
  }

  static successAlert({
    required String title,
   
    String? subtitle,
  }) {
    FrappeAlert.showAlert(
      icon: FrappeIcons.success,
      title: title,
      color: FrappePalette.darkGreen,
      subtitle: subtitle,
    );
  }
}