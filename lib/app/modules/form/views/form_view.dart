import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_mobile_custom/app/utils/frappe_alert.dart';

import 'package:get/get.dart';

import '../../../form/control.dart';
import '../../../generic/model/doc_type_response.dart';
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
   final FormHelper _formHelper = FormHelper();
   @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(
      tag: name,
      id:name,
      init: FormController(name: name, docType: docType),
      builder: (formController)=> Scaffold(
        appBar: AppBar(
          title:  Text(formController.name),

          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8,
              ),
              child: FrappeFlatButton(
                buttonType: ButtonType.primary,
                title: 'Update',
                onPressed: !formController.isDirty
                    ? () => FrappeAlert.warnAlert(title:"No changes in document" )
                    : () => formController.updateDoc(
                    _formHelper.getFormValue()
                ),
              ),
            ),

          ],
        ),

        body: SingleChildScrollView(
            child: FormBuilder(
              key: _formHelper.getKey(),

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
}
