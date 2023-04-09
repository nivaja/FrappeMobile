import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_mobile_custom/app/config/palette.dart';

import 'package:get/get.dart';

import '../../../config/frappe_palette.dart';
import '../../../form/control.dart';
import '../../../generic/model/doc_type_response.dart';
import '../../../utils/enums.dart';
import '../../../widget/frappe_button.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(

        child: FormBuilder(
          initialValue: controller.loginRequest.value,
          key: _formKey,
          child: Column(

            children: [
              buildDecoratedControl(control: FormBuilderTextField(
                  name: "url",decoration: Palette.formFieldDecoration(label: 'Server URL')),
                field: DoctypeField(
                fieldname: 'serverUrl',
                label: "Server URL",
              ),),
             buildDecoratedControl(control:  FormBuilderTextField(name: "usr",decoration: Palette.formFieldDecoration(label: 'Username'),), field: DoctypeField(fieldname: "usr", label: "Username")),
              PasswordField(),
              FrappeFlatButton(
                  title:"Login",
                  fullWidth: true,
                  height: 46,
                  buttonType: ButtonType.primary,
                  onPressed:
                      (){
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      print(_formKey.currentState?.value);
                      controller.login(_formKey.currentState!.value);

                    } else {
                      print(_formKey.currentState?.value);
                      debugPrint('validation failed');
                    }
                  }
              )

            ],
          ),
        ),
      ),
    );
  }


}


class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return buildDecoratedControl(
      control: Stack(
        alignment: Alignment.centerRight,
        children: [
          FormBuilderTextField(
            maxLines: 1,
            name: 'pwd',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
            ]),
            obscureText: _hidePassword,
            decoration: Palette.formFieldDecoration(
              label: "Password",
            ),
          ),
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
            ),
            child: Text(
              _hidePassword ? "Show" : "Hide",
              style: TextStyle(
                color: FrappePalette.grey[600],
              ),
            ),
            onPressed: () {
              setState(
                    () {
                  _hidePassword = !_hidePassword;
                },
              );
            },
          )
        ],
      ),
      field: DoctypeField(fieldname: "password", label: "Password"),
    );
  }
}
