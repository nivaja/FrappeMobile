import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:frappe_mobile_custom/app/api/frappe_api.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../config/config.dart';
import '../config/frappe_icons.dart';
import '../generic/model/get_doc_response.dart';
import '../utils/frappe_icon.dart';



class CommentBox extends StatelessWidget {
  final Map userInfo;
  final Comment data;
  final Function callback;

  CommentBox(this.data, this.callback, this.userInfo);

  @override
  Widget build(BuildContext context) {
    var time = timeago.format(DateTime.parse(data.creation));
    String commenterName = userInfo[data.owner]['fullname'];


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
                commenterName,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              subtitle: Text("commented $time"),
              trailing: Config.get('user') == data.owner
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
                        title: Text('Delete This Comment?'),
                        actions: <Widget>[

                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await FrappeAPI
                                  .deleteComment(data.name);
                              callback();
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
