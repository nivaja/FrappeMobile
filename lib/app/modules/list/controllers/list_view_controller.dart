import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../api/frappe_api.dart';
import '../../../generic/model/doc_type_response.dart';

class DocTypeListViewController extends GetxController {
  //TODO: Implement ListViewController
  String docType;
  DocTypeListViewController({required this.docType});

  var docList=[];
  late DoctypeResponse docTypeDoc;

  @override
  void onInit() async{
    getDocList();
    getDocTypeDoc();
    super.onInit();
  }
  Future getDocList({RefreshController? refreshController}) async{
    List list = await FrappeAPI.fetchList(
        doctype: docType,
        fieldnames: ['*'],
        offset: docList.length,
        pageLength: 10
    );
    list.isNotEmpty?refreshController?.loadComplete():refreshController?.loadNoData();


    docList.addAll(list);
    update();
  }
  void getDocTypeDoc() async{
    docTypeDoc = await FrappeAPI.getDoctype(docType);
    update();
  }

  Future onRefresh()async{
    var list = await FrappeAPI.fetchList(
        doctype: docType,
        fieldnames: ['*'],
        offset: 0,
        pageLength: 10
    );
    docList.clear();
    docList.addAll(list);
    update();
  }


}
