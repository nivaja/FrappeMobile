import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_mobile_custom/app/generic/model/doc_type_response.dart';
import 'package:frappe_mobile_custom/app/widget/image_picker.dart';

class ImagePickerField extends FormBuilderField<String>{
  ImagePickerField({
    required Map doc,
    required DoctypeField doctypeField,
    required BuildContext context,
    Key? key,
    FormFieldValidator? validator,
    bool enabled = true,
    Function(String?)? onChange

  }): super (
    name: doctypeField.fieldname,
    key: key,
    validator: validator,
    enabled: enabled,
    onChanged: onChange,
    builder: (FormFieldState<String> file) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImagePickerWidget(doc: doc, doctypeField: doctypeField,file: file,),
          if (file.hasError)
            Text(
              file.errorText!,
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
        ],
      );
    }
  );
}