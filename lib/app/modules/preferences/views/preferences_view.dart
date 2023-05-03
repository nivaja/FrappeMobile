import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/modules/preferences/views/session_defaults_view.dart';
import 'package:frappe_mobile_custom/app/widget/frappe_button.dart';
import 'package:frappe_mobile_custom/app/widget/user_avatar.dart';
import 'package:get/get.dart';

import '../../../api/ApiService.dart';
import '../../../api/frappe_api.dart';
import '../../../config/config.dart';
import '../../../config/frappe_icons.dart';
import '../../../config/frappe_palette.dart';
import '../../../utils/frappe_icon.dart';
import '../../login/views/login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(

           child: Padding(
             padding: const EdgeInsets.only(top: 150.0),
             child: Column(
               children: [
                 const SizedBox(
                   height: 8,
                 ),
                 CircularUserAvatar(
                   fullName: Config.get('username'),
                   size: 120,

                 ),
                 const SizedBox(
                   height: 6,
                 ),
                 Text(
                   Config.get('username'),
                   style: TextStyle(
                     fontWeight: FontWeight.w600,
                     color: FrappePalette.grey[900],
                   ),
                 ),
                 // TODO: add view profile
                 // SizedBox(
                 //   height: 3,
                 // ),
                 // Text(
                 //   'View Profile',
                 //   style: TextStyle(
                 //     color: FrappePalette.blue,
                 //     fontSize: 13,
                 //   ),
                 // ),
                 const SizedBox(
                   height: 14,
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(
                     horizontal: 16.0,
                   ),
                   child: Container(
                     padding: const EdgeInsets.symmetric(vertical: 16),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.rectangle,
                       boxShadow: [
                         BoxShadow(
                           color: Colors.grey[400]!,
                           blurRadius: 3.0,
                           offset: const Offset(0, 1),
                         ),
                       ],
                       borderRadius: BorderRadius.circular(
                         12,
                       ),
                     ),
                     child: Column(
                       children: [
                         ProfileListTile(
                           title: "Session Defaults",
                           onTap: () =>Get.to(()=>SessionDefaultsView()),
                           icon: const FrappeIcon(
                             FrappeIcons.my_settings,
                           ),
                         ),
                         const Padding(
                           padding: EdgeInsets.symmetric(
                             horizontal: 18.0,
                           ),
                           child: Divider(),
                         ),


                       ],
                     ),
                   ),
                 ),
                 const SizedBox(
                   height: 18,
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(
                     horizontal: 16.0,
                   ),
                   child: FrappeRaisedButton(
                     height: 48,
                     fullWidth: true,
                     onPressed: () async {
                       await FrappeAPI.logout();
                       Config.clear();
                       await ApiService.getCacheOptions()..store?.clean();
                       Get.offAll(()=>LoginView());
                     },
                     icon: FrappeIcons.logout,
                     titleWidget: Text(
                       "Logout",
                       style: TextStyle(
                         color: FrappePalette.red[600],
                       ),
                     ),
                   ),
                 ),
                 const SizedBox(
                   height: 30,
                 ),
               ],
             ),
           ),
         ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final Widget icon;

  const ProfileListTile({super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 10,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      leading: icon,
      trailing: FrappeIcon(
        FrappeIcons.arrow_right,
        size: 18,
        color: FrappePalette.grey[700],
      ),
      onTap: onTap,
      title: Text(title),
    );
  }
}

class ConstrainedFlexView extends StatelessWidget {
  final Widget child;
  final double minSize;
  final Axis axis;

  const ConstrainedFlexView(
      this.minSize, {super.key,
        required this.child,
        this.axis = Axis.vertical,
      });

  bool get isHz => axis == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        double viewSize = isHz ? constraints.maxWidth : constraints.maxHeight;
        if (viewSize > minSize) return child;
        return SingleChildScrollView(
          scrollDirection: axis,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: isHz ? double.infinity : minSize,
                maxWidth: isHz ? minSize : double.infinity),
            child: child,
          ),
        );
      },
    );
  }
}
