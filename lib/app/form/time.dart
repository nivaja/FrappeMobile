import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';



import '../config/palette.dart';
import '../generic/model/doc_type_response.dart';
import 'control.dart';

class Time extends StatelessWidget with  ControlInput {
  final DoctypeField doctypeField;
  final Key? key;
  final Map? doc;

  const Time({
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

    final initialValue = doc != null && doc![doctypeField.fieldname] != null
        ? DateFormat.Hms().parse((doc![doctypeField.fieldname] as String).replaceAll('T', ''))
        : DateFormat.Hms().parse(DateTime.now().toIso8601String().substring(11, 19));

    return FormBuilderDateTimePicker(
      key: key,
      initialValue: initialValue,
      inputType: InputType.time,
      valueTransformer: (val) {
        return val?.toIso8601String();
      },
      keyboardType: TextInputType.number,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
