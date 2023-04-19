
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_mobile_custom/app/widget/app_bar.dart';
import 'package:dio/dio.dart' as dio;
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
              title: 'save',
              onPressed: () {
                print(formHelper.getFormValue());
                if(formHelper.saveAndValidate()){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'Are you sure you want to save?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: ()async{

                      dio.Response res = await Get.find<NewFormController>(tag: docType).saveDoc(formHelper.getFormValue());
                      !getData?
                      Get.off(
                              ()=>FormView(name: res.data['docs'][0]['name'], docType: docType),
                          binding: FormBinding(docType: docType, name: res.data['docs'][0]['name'])
                      ):
                      Navigator.pop(context,res.data);
                      FrappeAlert.successAlert(title: '$docType saved');

                    },
                  ).show();
                }}
              ,
            )
            ,
          ),
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
                        docType:docType,
                        fields: Get.find<NewFormController>(tag: docType).fields.value,
                        doc: Get.find<NewFormController>(tag: docType).newDoc.value,
                      )..addAll([
                        Opacity(opacity: 0,child: Column(children: hiddenItems(),),)
                      ])
                  ),
            ),
          )
      ),
    );
  }

  hiddenItems(){
    List<FormBuilderTextField> hiddenItems=[];
    if (hiddenValues != null){
    for (var entry in hiddenValues!.entries){

        hiddenItems.add(FormBuilderTextField(name: entry.key,initialValue: entry.value,));
      }
    }
    return hiddenItems;
  }
}
