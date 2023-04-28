import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/api/frappe_api.dart';
import 'package:frappe_mobile_custom/app/generic/model/doc_type_response.dart';
import 'package:frappe_mobile_custom/app/utils/enums.dart';
import 'package:frappe_mobile_custom/app/widget/frappe_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Map doc;
  final DoctypeField doctypeField;
  final FormFieldState<String> file;

  const ImagePickerWidget({super.key, required this.doc, required this.doctypeField, required this.file});
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {

  // Create an instance of ImagePicker
  final picker = ImagePicker();

  // A list to store the picked images
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = constraints.maxWidth;
        final imageWidth = (maxWidth - 20) / 3;
        final imageHeight = imageWidth * 1.5;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: FrappeFlatButton(
                  onPressed:()=> _showPicker(context),
                  title: 'Pick an Image',
                  buttonType: ButtonType.primary,
                ),
              ),
              if(_imageFile != null)
                SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: Image.file(
                    File(_imageFile!.path),
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }



  Future<void> _showPicker(context) async {
    final picker = ImagePicker();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select an option"),
          actions: [
            TextButton(
              onPressed: () async {
                final pickedFile = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 800,
                  maxHeight: 800,
                );
                setState(() {
                  _imageFile = pickedFile;
                  widget.file.didChange(pickedFile!.path);

                });
                Navigator.of(context).pop();
              },
              child: const Text("Take a new photo"),
            ),
            TextButton(
              onPressed: () async {
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 800,
                  maxHeight: 800,
                );
                setState(() {
                  _imageFile = pickedFile;
                  widget.file.didChange(pickedFile!.path);

                });
                Navigator.of(context).pop();
              },
              child: const Text("Choose from gallery"),
            ),
          ],
        );
      },
    );
  }
}