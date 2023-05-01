import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/utils/enums.dart';
import 'package:frappe_mobile_custom/app/widget/frappe_button.dart';

import '../utils/frappe_alert.dart';

class CommentInputBox extends StatefulWidget {
  final Function(String) onSave;
  final Function refresh;

  const CommentInputBox({Key? key, required this.onSave,required this.refresh}) : super(key: key);

  @override
  _CommentInputBoxState createState() => _CommentInputBoxState();
}

class _CommentInputBoxState extends State<CommentInputBox> {
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Comment'),
      content: SizedBox(
        width:  MediaQuery.of(context).size.width,
        child: TextFormField(
          maxLines: 5,

          controller: _commentController,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'Please comment here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 0.5,
              ),
            ),
            filled: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Discard'),
        ),
        _isLoading
            ?  Container(
          alignment: Alignment.center,
          width: 20.0,
          height: 20.0,
          child: const CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ) // Show loading indicator if API request is in progress
            : FrappeFlatButton(
          onPressed: () async {
            setState(() {
              _isLoading = true; // Set state to indicate that API request is in progress
            });
            if (_commentController.text.isNotEmpty) {
              await widget.onSave(_commentController.text);
              await widget.refresh();
              Navigator.pop(context);
            } else {
              FrappeAlert.warnAlert(title:'Cannot Save Empty Comment');
            }
            setState(() {
              _isLoading = false; // Reset state after API request is completed
            });

          },
          title: 'Save',
          buttonType: ButtonType.primary,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
