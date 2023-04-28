import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';

import '../../../form/control.dart';
import '../../../generic/model/doc_type_response.dart';
import '../../../utils/form_helper.dart';

class JustFormView extends GetView {
  final FormHelper formHelper;
  final List<DoctypeField> fields;
  final Map doc;

  const JustFormView({
    required this.formHelper,
    required this.fields,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    return  FormBuilder(
        onChanged: () {
          formHelper.save();
        },
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formHelper.getKey(),
        child: SingleChildScrollView(
          child: Column(
            children: generateLayout(
              fields: fields,
              doc: doc,
            ),
          ),
        ),
      );
  }
}
