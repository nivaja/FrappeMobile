import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_mobile_custom/app/generic/common.dart';
import 'package:frappe_mobile_custom/app/utils/indicator.dart';
import 'package:get/get.dart';
import '../../../config/frappe_palette.dart';
import '../../../form/control.dart';
import '../../../utils/enums.dart';
import '../../../utils/form_helper.dart';
import '../../../widget/frappe_button.dart';
import '../controllers/form_controller.dart';

class FormView extends GetView<FormController> {
  final  String docType;
  final String name;
  FormView({
    required this.name,
    required this.docType,
    Key? key,
  }) : super(key: key);
  final _formHelper = FormHelper();
  @override
  Widget build(BuildContext context) {

    return GetBuilder<FormController>(
      id:name,
      builder: (formController)=>
        Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0.8,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: FrappePalette.grey[900],
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: !formController.isLoading?Indicator.buildStatusButton([0,formController.doc['status']]):const SizedBox(),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8,
              ),
              child:   _showActionButton(formController, context)
              ,
            ),
          ],
        ),
        body: formController.isLoading?const Center(child: CircularProgressIndicator(),):SingleChildScrollView(
            child: FormBuilder(
              key: _formHelper.getKey(),
              enabled: ![1,2].contains(formController.doc['docstatus']),
              onChanged: (){
                _formHelper.save();
                formController.handleChange();
              },
              child: Column(
                  children: generateLayout(
                    fields: formController.fields,
                    doc: formController.doc,
                  )
              ),
            )
        ),
      ),
    );

  }

  Widget? _showActionButton(FormController formController, BuildContext context) {
    if (formController.docTypeDoc?.docs[0].isSubmittable != 1) {
      return null;
    }
    final docstatus = formController.doc['docstatus'];
    final isDirty = formController.isDirty;

    if (docstatus == 0 && !isDirty) {
      return _actionButton(formController, context,'submit',btnOkOnPress: ()=>formController.submitDoc());
    } else if (docstatus == 1) {
      return _actionButton(formController, context,'cancel',btnOkOnPress: ()=>formController.cancelDoc());
    } else if (docstatus == 0 && isDirty) {
      return _actionButton(formController, context,'save',btnOkOnPress: ()=>formController.updateDoc( _formHelper.getFormValue()));
    }
    return null;
  }

  FrappeFlatButton _actionButton(FormController formController,BuildContext context,String title,{required Function btnOkOnPress}){
    return FrappeFlatButton(
      buttonType: title=='cancel'?ButtonType.danger:ButtonType.primary,
      title: title,
      onPressed: () =>
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Are you sure you want to $title?',
        btnCancelOnPress: () {},
        btnOkOnPress: (){
          try {
            if(_formHelper.saveAndValidate()) {
              btnOkOnPress();
            }
          } on ErrorResponse catch(e){
            AwesomeDialog(
              context: context,
              title: 'Error',
              desc: e.statusMessage,
              dialogType: DialogType.error,
            ).show();
          }catch (e){rethrow;}
        }
        ,
      ).show(),
    );
  }
}
