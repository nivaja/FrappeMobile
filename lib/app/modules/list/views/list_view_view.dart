import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';

import '../../form/views/form_view.dart';
import '../controllers/list_view_controller.dart';
import 'list_item.dart';

class DocListView extends GetView<DocTypeListViewController>{
  String DocType;

  DocListView({Key? key, required this.DocType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() =>DocTypeListViewController());
    controller.getList(DocType);
    return Scaffold(
        appBar: AppBar(
          title: const Text('ListViewView'),
          centerTitle: true,
        ),
        body: Obx(()=>
            ListView.builder(
                itemCount:controller.docList.length,
                itemBuilder: ((buildContext, index) {
              late var e = controller.docList[index] as Map;
              return _generateItem(

                data: e,
                onListTap: (){
                    Get.to(
                        ()=>FormView(
                          name:e['name'],
                          docType:DocType,
                        )

                    );
                },

              );
            }))      )
    );
  }


  Widget _generateItem({
    required Map data,
    required void Function() onListTap,
    // required Function onButtonTap,
  }) {
    return ListItem(
      doctype:data['name'],
      onListTap: onListTap,

      // onButtonTap: onButtonTap,
      title: data['title']??data["name"],
      modifiedOn: timeago.format(
        DateTime.parse(
          data['modified'],
        ),
      ),
      name: data["name"],
      status:data["status"],
    );
  }

}
