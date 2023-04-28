import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/config/frappe_palette.dart';
import 'package:frappe_mobile_custom/crm/modules/home/home_controller.dart';
import 'package:geolocator/geolocator.dart';
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
              icon: Icon(Icons.add_shopping_cart),
              label: 'pos-invoice',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'payment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'customer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_rounded),
              label: 'lead',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
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
