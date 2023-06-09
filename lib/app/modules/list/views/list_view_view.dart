import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/modules/form/bindings/form_binding.dart';
import 'package:frappe_mobile_custom/app/modules/form/views/just_form_view.dart';
import 'package:frappe_mobile_custom/app/utils/frappe_icon.dart';
import 'package:frappe_mobile_custom/app/widget/app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';

import '../../../generic/connectivity_controller.dart';
import '../../form/views/form_view.dart';
import '../../form/views/new_form_view.dart';
import '../controllers/list_view_controller.dart';
import 'list_item.dart';

class DocListView extends GetView<DocTypeListViewController>{
  String docType;
  final _refreshController =RefreshController(initialRefresh: false);

  DocListView({Key? key, required this.docType}) : super(key: key);
  final _connectivityController = Get.find<ConnectivityController>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.to(()=>NewFormView(docType: docType,));
      },
        child: const Icon(Icons.add),

      ),
        appBar: appBar(title: docType),
        body: Column(
          children: [
            Obx(() =>_showConnectionStatus()),
            Expanded(
              child: GetBuilder<DocTypeListViewController>(
                init: DocTypeListViewController(docType: docType),
                builder: (docTypeListController) =>SmartRefresher(
                  enablePullUp: true,
                  controller:  _refreshController,
                  header: const ClassicHeader(),
                  onRefresh: ()=>_onRefresh(docTypeListController),
                  onLoading: ()=>_onLoading(),

                  child: ListView.builder(
                      itemCount:docTypeListController.docList.length,
                      itemBuilder: ((buildContext, index) {
                        late var e = docTypeListController.docList[index] as Map;
                        return _generateItem(

                          data: e,
                          onListTap: (){
                            Get.to(
                                    ()=>FormView(
                                  name:e['name'],
                                  docType:docTypeListController.docType,
                                ),
                              binding: FormBinding(docType: docTypeListController.docType, name: e['name'])

                            );
                          },

                        );
                      })),
                ),

    ),
            ),
          ],
        )
    );
  }

  _onRefresh(DocTypeListViewController controller)async{
       await controller.onRefresh();
       _refreshController.refreshCompleted();
       _refreshController.footerMode?.value=LoadStatus.canLoading;
  }
  _onLoading()async{
    await controller.getDocList(refreshController: _refreshController);
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
      status: [data["docstatus"], data["status"]],
    );
  }

  Widget _showConnectionStatus(){
    switch(_connectivityController.connectionType.value){
      case 1:
        return _connectionWidget('Wifi Connected', Colors.lightGreen);
      case 2:
        return _connectionWidget('Mobile Data Connected', Colors.lightGreen);
      default:
        return _connectionWidget('No Internet', Colors.yellow);
    }
  }
  Widget _connectionWidget(String msg, Color color){
    return Container(
      width: double.maxFinite,
      height: 25,
      alignment: Alignment.center,
      color: color,
      child: Text(msg),
    );
  }

}
