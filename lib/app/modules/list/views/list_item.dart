import 'package:flutter/material.dart';

import '../../../config/frappe_icons.dart';
import '../../../config/frappe_palette.dart';
import '../../../config/palette.dart';
import '../../../utils/frappe_icon.dart';
import '../../../utils/indicator.dart';


class ListItem extends StatelessWidget {
  final String? title;
  final String modifiedOn;
  final String name;
  final String doctype;



  final String status;


  final void Function() onListTap;


  ListItem({
    required this.doctype,

    required this.status,
    required this.title,

    required this.modifiedOn,
    required this.name,
    required this.onListTap,

  });

  @override
  Widget build(BuildContext context) {
    double colWidth = MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTap: onListTap,
      child: Card(
        margin: EdgeInsets.zero,
        shape: Border.symmetric(
          vertical: BorderSide(
            width: 0.1,
          ),
        ),
        elevation: 0,
        child: Container(
          height: 112,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Palette.secondaryButtonColor,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: colWidth,
                    child: Text(
                      title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: FrappePalette.grey[900],

                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 1,
                      style: TextStyle(
                        color: FrappePalette.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                    child: Icon(
                      Icons.lens,
                      size: 5,
                      color: Palette.secondaryTxtColor,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      modifiedOn,
                      style: TextStyle(
                        color: FrappePalette.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Indicator.buildStatusButton(
                    doctype,
                    status,
                  ),
                  VerticalDivider(),
                  FrappeIcon(
                    FrappeIcons.message_1,
                    size: 16,
                    color: FrappePalette.grey[500],
                  ),
                  SizedBox(
                    width: 6.0,
                  ),

                  VerticalDivider(),

                  SizedBox(
                    width: 6.0,
                  ),

                  Spacer(),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
