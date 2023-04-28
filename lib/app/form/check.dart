import 'package:form_builder_validators/form_builder_validators.dart';

import '../config/frappe_palette.dart';
import '../config/palette.dart';
import '../generic/model/doc_type_response.dart';
import '../widget/form_builder_check_box.dart';
import 'control.dart';
import 'package:flutter/material.dart';
class Check extends StatelessWidget with ControlInput {
  final DoctypeField doctypeField;
  final Key? key;
  final Map? doc;
  final Function? onChanged;

  const Check({
    required this.doctypeField,
    this.onChanged,
    this.key,
    this.doc,
  });

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];

    var f = setMandatory(doctypeField);

    if (f != null) {
      validators.add(
        f(context),
      );
    }

    return CustomFormBuilderCheckbox(
      name: doctypeField.fieldname,
      key: key,
      enabled:
      doctypeField.readOnly != null ? doctypeField.readOnly == 0 : true,
      valueTransformer: (val) {
        return val == true ? 1 : 0;
      },
      activeColor: FrappePalette.blue,
      initialValue: doc != null ? doc![doctypeField.fieldname] == 1 : null,

      label: Text(
        doctypeField.label!,
        style: TextStyle(
          color: FrappePalette.grey[700],
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
        filled: false,
        field: "check",
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
