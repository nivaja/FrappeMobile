import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/config/frappe_palette.dart';
import 'package:frappe_mobile_custom/crm/modules/home/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: '/pos-invoice',
        onGenerateRoute: controller.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'pos-invoice',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'payment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'customer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: 'login',
            ),
          ],
          currentIndex: controller.currentIndex.value,
          unselectedItemColor: Colors.grey,
          selectedItemColor: FrappePalette.blue,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
