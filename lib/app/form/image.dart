import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_mobile_custom/app/api/ApiService.dart';
import 'package:frappe_mobile_custom/app/form/control.dart';
import 'package:frappe_mobile_custom/app/generic/model/doc_type_response.dart';
import 'package:frappe_mobile_custom/app/widget/image_picker_field.dart';
import 'package:photo_view/photo_view.dart';

import '../config/config.dart';
import '../widget/photo_viewer.dart';


class ImageField extends StatelessWidget with ControlInput{
  final Map doc;
  final DoctypeField doctypeField;

  const ImageField({super.key, required this.doc, required this.doctypeField});

  @override
  Widget build(BuildContext context) {

    List<String? Function(dynamic)> validators = [];

    var f = setMandatory(doctypeField);

    if (f != null) {
      validators.add(
        f(context,errorText: 'Please Attach an Image'),
      );
    }

    // TODO: implement build
   return doc[doctypeField.fieldname] != null
        ?
   GestureDetector(
     onTap: () {
       Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => FullScreenImage(
             imageUrl: '${Config().baseUrl}${doc[doctypeField.fieldname]}',
           ),
         ),
       );
     },
     child: SizedBox(
       width: double.infinity,
       height: 100,
       child: CachedNetworkImage(
         imageUrl: '${Config().baseUrl}${doc[doctypeField.fieldname]}',
         placeholder: (context, url) => CircularProgressIndicator(),
         errorWidget: (context, url, error) => Icon(Icons.error),
       ),
     ),
   )
    :
     ImagePickerField(doc: doc, doctypeField: doctypeField, context: context,validator:  FormBuilderValidators.compose(validators),);
  }

}


