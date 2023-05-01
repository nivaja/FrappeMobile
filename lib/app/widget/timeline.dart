import 'package:flutter/material.dart';


import 'package:timelines/timelines.dart' as timeline;

import '../config/frappe_palette.dart';
import '../generic/model/get_doc_response.dart';
import '../utils/enums.dart';
import '../utils/utils.dart';
import 'comment_box.dart';
import 'doc_version.dart';


class Timeline extends StatelessWidget {
  final Docinfo docinfo;
  final String doctype;
  final String name;

  final Function refreshCallback;

  Timeline({
    required this.docinfo,
    required this.doctype,
    required this.name,

    required this.refreshCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List<Widget> children = [
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Row(
              children: [
                Text(
                  'Activity',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: FrappePalette.grey[900],
                  ),
                ),
                Spacer(),
                Text(
                  "Communication Only",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: FrappePalette.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ];


        for (var event in _processData()) {
          if (event["_category"] == "communications") {
            event = Communication.fromJson(event);
          } else if (event["_category"] == "comments") {
            event = Comment.fromJson(event);
          }
          try{
            if (event is Comment) {
              children.add(
                CommentBox(
                  event,
                      () {
                    refreshCallback();
                  },
                ),
              );
            } else {


              children.add(DocVersion(event));



            }
          }catch (e){}}


        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: timeline.Timeline.tileBuilder(
            theme: timeline.TimelineThemeData(
              connectorTheme: timeline.ConnectorThemeData(
                space: 51,
                thickness: 2,
                color: FrappePalette.grey[200],
              ),
              nodePosition: 0,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            builder: timeline.TimelineTileBuilder.connected(
              indicatorBuilder: (context, idx) {
                return CircleAvatar(
                  radius: 10,
                  backgroundColor: FrappePalette.grey[300],
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 8,
                    child: Icon(
                      Icons.lens,
                      size: 6,
                      color: FrappePalette.grey[600],
                    ),
                  ),
                );
              },
              connectorBuilder: (_, index, __) {
                return timeline.SolidLineConnector();
              },
              itemCount: children.length,
              contentsBuilder: (context, idx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: children[idx],
                );
              },
            ),
          ),
        );
      },
    );
  }

  List _processData() {
    var _events = [
      ...docinfo.comments.map(
            (comment) {
          var c = comment.toJson();
          c["_category"] = "comments";
          return c;
        },
      ).toList(),
      ...docinfo.communications.map((communication) {
        var c = communication.toJson();
        c["_category"] = "communications";
        return c;
      }).toList(),
      ...docinfo.versions.map((version) {
        var v = version.toJson();
        v["_category"] = "versions";
        return v;
      }).toList(),
      ...docinfo.views.map((view) {
        var v = view.toJson();
        v["_category"] = "views";
        return v;
      }).toList(),
    ];
    var events = sortBy(_events, "creation", Order.desc);
    return events;
  }
}
