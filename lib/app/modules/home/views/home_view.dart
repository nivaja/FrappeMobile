import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_mobile_custom/app/widget/frappe_button.dart';

import 'package:get/get.dart';

import '../../../config/palette.dart';
import '../../../form/control.dart';
import '../../../utils/enums.dart';
import '../../list/views/list_view_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final GlobalKey<FormBuilderState> _formKey =  GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(name: 'docType',
                  decoration: Palette.formFieldDecoration(
                    label: 'DocType',
                  ),
                  validator: FormBuilderValidators.required(context)),

              FrappeFlatButton(onPressed: () {
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                  debugPrint(_formKey.currentState?.value.toString());
                  Get.to(()=>DocListView( DocType: _formKey.currentState!.value['docType'].toString()));
                } else {
                  debugPrint(_formKey.currentState?.value.toString());
                  debugPrint('validation failed');
                }


              },
                title: 'Get DocType',
                buttonType: ButtonType.primary,)
            ],
          ),
        ),


      ),





    );
  }
}
