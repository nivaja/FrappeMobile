import 'package:flutter/material.dart';


import '../generic/model/doc_type_response.dart';
import '../widget/form_builder_table.dart';

class CustomTable extends StatelessWidget {
  final DoctypeField doctypeField;
  final Map doc;

  CustomTable({
    required this.doctypeField,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    if (doc[doctypeField.fieldname] == null) {
      doc[doctypeField.fieldname] = [];
    }

    return FormBuilderTable(
      name: doctypeField.fieldname,
      context: context,
      doctype: doctypeField.options,
      initialValue: doc[doctypeField.fieldname],
    );
  }
}
