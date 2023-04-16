import 'package:flutter/material.dart';

import '../config/frappe_palette.dart';

appBar(
{
  required String title,
  List<Widget>? actions,
  Widget? status
}
    ){
  return AppBar(
    foregroundColor: Colors.black,
    elevation: 0.8,
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: FrappePalette.grey[900],
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: status??const SizedBox(),
        ),
      ],
    ),
    actions: actions,
  );
}