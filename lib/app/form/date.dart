import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:intl/intl.dart';


import '../config/palette.dart';
import '../generic/model/doc_type_response.dart';
import '../utils/utils.dart';
import 'control.dart';

class Date extends StatelessWidget with  ControlInput {
  final DoctypeField doctypeField;

  final Key? key;
  final Map? doc;

  const Date({
    this.key,
    required this.doctypeField,
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

    return FormBuilderDateTimePicker(
      key: key,

      enabled: doctypeField.readOnly != 1,
      inputType: InputType.date,
      valueTransformer: (val) {
        return val?.toIso8601String();
      },
      format: DateFormat(
        "dd-MM-yyyy",
      ),
      initialValue:
      doc != null ? parseDate(doc![doctypeField.fieldname]):null,
      keyboardType: TextInputType.number,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
