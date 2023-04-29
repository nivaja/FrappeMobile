import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/config/frappe_palette.dart';
import 'package:frappe_mobile_custom/crm/modules/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder:(homeController)=> Scaffold(
        body:LazyLoadIndexedStack(
            index:homeController.currentIndex ,
            children: homeController.screens,
          ),
        bottomNavigationBar: BottomNavigationBar(
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
            currentIndex: controller.currentIndex,
            unselectedItemColor: Colors.grey,
            selectedItemColor: FrappePalette.blue,
            onTap: controller.changePage,
          ),
        ),
    );
  }




}
