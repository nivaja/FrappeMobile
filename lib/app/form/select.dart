import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';



import '../config/frappe_icons.dart';
import '../config/palette.dart';
import '../generic/model/doc_type_response.dart';
import '../utils/frappe_icon.dart';
import 'control.dart';

class Select extends StatelessWidget with  ControlInput {
  final DoctypeField doctypeField;

  final Key? key;
  final Map? doc;

  const Select({
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

    List opts;
    if (doctypeField.options is String) {
      opts = doctypeField.options.split('\n');
    } else {
      opts = doctypeField.options ?? [];
    }

    return FormBuilderDropdown(
      key: key,

      icon: FrappeIcon(
        FrappeIcons.select,
      ),
      initialValue: doc != null
          ? doc![doctypeField.fieldname]
          : doctypeField.defaultValue,
      name: doctypeField.fieldname,
      hint: Text(doctypeField.label!),
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
      items: opts.toSet().toList().map<DropdownMenuItem>((option) {
        return DropdownMenuItem(
          value: option,
          child: option != null
              ? Text(
            option,
            style: TextStyle(
              color: Colors.black,
            ),
          )
              : Text(''),
        );
      }).toList(),
    );
  }
}
