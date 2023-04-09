import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';


import '../config/palette.dart';
import '../generic/model/doc_type_response.dart';
import 'control.dart';

class Float extends StatelessWidget with  ControlInput {
  final DoctypeField doctypeField;

  final Key? key;
  final Map? doc;

  const Float({
    required this.doctypeField,
    this.key,
    this.doc,
  });

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic?)> validators = [];

    var f = setMandatory(doctypeField);

    if (f != null) {
      validators.add(
        f(context),
      );
    }

    return FormBuilderTextField(
      key: key,
      initialValue: doc != null
          ? doc![doctypeField.fieldname] != null
          ? doc![doctypeField.fieldname].toString()
          : null
          : null,
      keyboardType: TextInputType.number,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
