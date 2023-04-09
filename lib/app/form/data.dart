import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';


import '../config/palette.dart';
import '../generic/model/doc_type_response.dart';
import 'control.dart';

class Data extends StatelessWidget with  ControlInput {
  final DoctypeField doctypeField;
  final Widget? prefixIcon;
  final Color? color;

  final Key? key;
  final Map? doc;

  const Data({
    required this.doctypeField,
    this.key,
    this.doc,
    this.color,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];

    var f = setMandatory(doctypeField);

    if (f != null) {
      validators.add(f(context));
    }

    return FormBuilderTextField(
      key: key,
      readOnly: doctypeField.readOnly == 1,
      initialValue: doc != null ? doc![doctypeField.fieldname] : null,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
        fillColor: color,
        prefixIcon: prefixIcon != null
            ? Padding(
          padding: EdgeInsets.only(
            right: 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [prefixIcon!],
          ),
        )
            : null,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
