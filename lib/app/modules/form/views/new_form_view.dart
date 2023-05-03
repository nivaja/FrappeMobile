

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_mobile_custom/app/widget/app_bar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../form/control.dart';
import '../../../utils/enums.dart';
import '../../../utils/form_helper.dart';
import '../../../utils/frappe_alert.dart';
import '../../../utils/indicator.dart';
import '../../../widget/frappe_button.dart';
import '../bindings/form_binding.dart';
import '../controllers/new_form_controller.dart';
import 'form_view.dart';

class NewFormView extends StatelessWidget {
  final String docType;
  final bool getData;
  final FormHelper formHelper;
  final Map? hiddenValues;
  NewFormView({ Key? key, required this.docType,this.getData=false,required this.formHelper,this.hiddenValues}) : super(key:key);



  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => NewFormController(docType: docType,formHelper: formHelper),tag: docType);
    return Scaffold(
      appBar: appBar(title:'New $docType' ,
        status: Indicator.buildStatusButton([0,'Not Saved']),
        actions:[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8,
            ),
            child:  FrappeFlatButton(
              buttonType: ButtonType.primary,
              title: 'Save',
              onPressed: () {
                if(formHelper.saveAndValidate()){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'Are you sure you want to save?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: ()async{
                      dio.Response res =
                      await Get.find<NewFormController>(tag: docType).saveDoc();
                      if(!getData) {
                        Get.off(
                                () =>
                                FormView(name: res.data['docs'][0]['name'],
                                    docType: docType),
                            binding: FormBinding(docType: docType,
                                name: res.data['docs'][0]['name'])
                        );
                      }else {

                        Navigator.pop(context, res.data['docs'][0]['name']);
                        FrappeAlert.successAlert(title: '$docType saved');

                      }
                    },
                  ).show();
                }}
              ,
            )
            ,
          ),
          PopupMenuButton(itemBuilder: (BuildContext context){
            return ['Reload'].map((e) => PopupMenuItem(child:Text(e),
              onTap: () async=>
              await Get.find<NewFormController>(tag: docType).getFields(cachePolicy: CachePolicy.refreshForceCache), )
            ).toList();
          })
        ],
      ),
      body: SingleChildScrollView(
          child: FormBuilder(
            key: formHelper.getKey(),
            onChanged: (){

              formHelper.save();
            },
            child: Obx(
                  ()=>
                  Column(
                      children: generateLayout(
                        fields: Get.find<NewFormController>(tag: docType).fields.value,
                        doc: Get.find<NewFormController>(tag: docType).newDoc.value,
                      )..addAll([
                        Opacity(opacity: 0,child: Column(children: hiddenItems()                          ,),),
                        FutureBuilder(
                          future: getCurrentLocation(),
                          builder: (BuildContext context, AsyncSnapshot<Position?> snapshot) {
                            if(snapshot.hasData){
                              return Opacity(
                                opacity: 0,
                                child: Column(
                                  children: [

                                    FormBuilderTextField(name: 'latitude',initialValue: snapshot.data?.latitude.toString(),),
                                    FormBuilderTextField(name: 'longitude',initialValue: snapshot.data?.longitude.toString(),),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox();
                          },

                        ),

                      ])
                  ),
            ),
          )
      ),
    );
  }

  List<FormBuilderTextField> hiddenItems(){
    List<FormBuilderTextField> hiddenItems=[];
    if (hiddenValues != null){
      for (var entry in hiddenValues!.entries){
        if(entry.value  is double){
          hiddenItems.add(FormBuilderTextField(name: entry.key,initialValue: entry.value.toString(),valueTransformer: (value)=>double.parse(value.toString()),));
        }else if(entry.value  is int){
          hiddenItems.add(FormBuilderTextField(name: entry.key,initialValue: entry.value.toString(),valueTransformer: (value)=>int.parse(value.toString()),));
        }
        hiddenItems.add(FormBuilderTextField(name: entry.key,initialValue: entry.value.toString(),));
      }
    }
    return hiddenItems;
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, ask the user to enable them
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        // User did not enable location services, return null
        return null;
      }
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, handle appropriately
      return null;
    }

    if (permission == LocationPermission.denied) {
      // Request location permissions
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        // Location permissions are not granted, return null
        return null;
      }
    }

    // Get current location
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }
}
