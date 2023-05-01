import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:frappe_mobile_custom/app/api/frappe_api.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../config/frappe_icons.dart';
import '../generic/model/get_doc_response.dart';
import '../utils/frappe_icon.dart';



class CommentBox extends StatelessWidget {
  final Comment data;
  final Function callback;

  CommentBox(this.data, this.callback);

  @override
  Widget build(BuildContext context) {
    var time = timeago.format(DateTime.parse(data.creation));
    String commenterName;


    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(
                'a',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              subtitle: Text("commented $time"),
              trailing: "nivajasingh359@gmail.com" == data.owner
                  ? IconButton(
                padding: EdgeInsets.zero,
                icon: FrappeIcon(
                  FrappeIcons.close_alt,
                  size: 16,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await FrappeAPI
                                  .deleteComment(data.name);
                              callback();
                            },
                          ),
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Html(
                data: data.content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
