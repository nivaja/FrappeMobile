import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:frappe_mobile_custom/app/api/ApiService.dart';

import '../generic/common.dart';
import '../generic/model/doc_type_response.dart';
import '../generic/model/get_doc_response.dart';
import '../generic/model/upload_file_response.dart';
import '../utils/utils.dart';

class FrappeAPI{
  static Future<DoctypeResponse> getDoctype(String doctype,{CachePolicy cachePolicy=CachePolicy.forceCache}) async {
    var queryParams = {
      'doctype': doctype,
    };
    try {
      CacheOptions cacheOptions =await ApiService.getCacheOptions();
      final response = await ApiService.dio!.get('/method/frappe.desk.form.load.getdoctype',
          queryParameters: queryParams,
          options: cacheOptions.copyWith(policy: cachePolicy).toOptions()
      );

      if (response.statusCode == HttpStatus.ok || response.statusCode ==304) {
        List metaFields = response.data["docs"][0]["fields"];
        response.data["docs"][0]["field_map"] = {};

        metaFields.forEach((field) {
          response.data["docs"][0]["field_map"]["${field["fieldname"]}"] = true;
        });

        return DoctypeResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        print('${response.statusMessage} -> ${response.statusCode}');
        throw ErrorResponse(
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        rethrow;
      }
    }
  }

  static Future<Map> searchLink({
    String? doctype,
    String? refDoctype,
    String? txt,
    int? pageLength,
    Map? filters,
  }) async {
    var queryParams = {
      'txt': txt,
      'doctype': doctype,
      'reference_doctype': refDoctype,
      'ignore_user_permissions': 0,
    };

    if (pageLength != null) {
      queryParams['page_length'] = pageLength;
    }

    if (filters != null && filters.isNotEmpty) {
      queryParams['filters'] = jsonEncode(filters);
    }

    try {

      final response = await ApiService.dio!.get(
        '/method/frappe.desk.search.search_link',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200 || response.statusCode == 304) {
        return response.data;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw e;
      }
    }
  }

  static Future<GetDocResponse> getDoc(String doctype, String name) async {
    var queryParams = {
      'doctype': doctype,
      'name': name,
    };

    try {
      final response = await ApiService.dio!.get(
        '/method/frappe.desk.form.load.getdoc',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 304) {
        return GetDocResponse.fromJson(response.data);
      } else if (response.statusCode == 403) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        rethrow;
      }
    }
  }


  static Future<Map> runDocMethod(String docType, String name,String method) async {
    var queryParams = {
      'run_method': method,
    };

    try {
      final response = await ApiService.dio!.post(
        '/resource/$docType/$name',
        queryParameters: queryParams,
      );
      if(response.statusCode ==200 || response.statusCode == 304){
        return response.data;
      }

      else if (response.statusCode == 403) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          rethrow;
        }
      } else {
        rethrow;
      }
    }
  }


  static Future<List> fetchList({
    required String doctype,
    List? fieldnames,
    String? orderBy,
    List? filters,
    int? pageLength,
    int? offset,
    CachePolicy cachePolicy = CachePolicy.forceCache
  }) async {
    var queryParams = {
      'doctype': doctype,
      'fields': jsonEncode(fieldnames),
      'page_length': pageLength.toString(),
      'order_by':'modified desc'

    };

    queryParams['limit_start'] = offset.toString();

    if (filters != null && filters.length != 0) {
      queryParams['filters'] = jsonEncode(filters);
    }

    try {
      CacheOptions cacheOptions =await ApiService.getCacheOptions();
      final response = await ApiService.dio!.get(
          '/method/frappe.desk.reportview.get',
          queryParameters: queryParams,
          options: cacheOptions.copyWith(policy: cachePolicy).toOptions()
      );
      if (response.statusCode == HttpStatus.ok || response.statusCode==304) {
        var l = response.data["message"];
        var newL = [];

        if (l.length == 0) {
          return newL;
        }

        for (int i = 0; i < l["values"].length; i++) {
          var o = {};
          for (int j = 0; j < l["keys"].length; j++) {
            var key = l["keys"][j];
            var value = l["values"][i][j];


            o[key] = value;
          }
          newL.add(o);
        }


        return newL;
      }


      else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      }
      else {
        rethrow;
      }
    }
  }

  static Future updateDocs({
    required String docType,
    required String name,
    required Map data
  }) async {
    try {
      final response = await ApiService.dio!.put(
        '/resource/$docType/$name',
        data: data,
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null &&
            e.response!.data != null &&
            e.response!.data["_server_messages"] != null) {
          var errorMsg = getServerMessage(e.response!.data["_server_messages"]);

          throw ErrorResponse(
            statusCode: e.response!.statusCode,
            statusMessage: errorMsg,
          );
        } else {
          if (e.error is SocketException) {
            throw ErrorResponse(
              statusCode: HttpStatus.serviceUnavailable,
              statusMessage: e.error.message,
            );
          } else {
            throw ErrorResponse(
              statusCode: e.response?.statusCode,
              statusMessage: e.response?.statusMessage,
            );
          }
        }
      } else {
        throw ErrorResponse();
      }
    }

  }

  static Future saveDocs(String doctype, Map formValue) async {
    var data = {
      "doctype": doctype,
      ...formValue,
    };


    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: const CircularProgressIndicator(backgroundColor: Colors.white),
        status: 'Please Wait...',);
      final response = await ApiService.dio!.post(
        '/method/frappe.desk.form.save.savedocs',
        data: "doc=${Uri.encodeComponent(json.encode(data))}&action=Save",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 304) {
        return response;
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null &&
            e.response?.data != null &&
            e.response?.data["_server_messages"] != null) {
          var errorMsg = getServerMessage(e.response?.data["_server_messages"]);
          throw ErrorResponse(
            statusCode: e.response?.statusCode,
            statusMessage: errorMsg,
          );
        } else {
          if (e.error is SocketException) {
            throw ErrorResponse(
              statusCode: HttpStatus.serviceUnavailable,
              statusMessage: e.error.message,
            );
          } else {
            throw ErrorResponse(
              statusCode: e.error.statusCode,
              statusMessage: e.error.statusMessage,
            );
          }
        }
      } else {
        throw ErrorResponse();
      }
    }finally{
      EasyLoading.dismiss();
    }
  }

  static Future postComment(
      String refDocType, String refName, String content, String email) async {
    var queryParams = {
      'reference_doctype': refDocType,
      'reference_name': refName,
      'content': content,
      'comment_email': email,
      'comment_by': email
    };

    final response = await ApiService.dio!.post(
        '/method/frappe.desk.form.utils.add_comment',
        data: queryParams,
        options: Options(contentType: Headers.formUrlEncodedContentType));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Something went wrong');
    }
  }
  static Future deleteComment(String name) async {
    var queryParams = {
      'doctype': 'Comment',
      'name': name,
    };

    final response = await ApiService.dio!.post('/method/frappe.client.delete',
        data: queryParams,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Something went wrong');
    }
  }

  static Future<UploadedFileResponse> uploadImage({
    required String doctype,
    String? name,
    String? filename,
    required String filePath,
  }) async {

    String fileName = filename ?? filePath.split('/').last;
    final file = await MultipartFile.fromFile(filePath,filename: fileName);
    final formData = FormData.fromMap({
      "file": file,
      "is_private": 0
    });

    var response = await ApiService.dio!.post(
      "/method/upload_file",
      data: formData,
    );
    if (response.statusCode == 200) {
      return UploadedFileResponse.fromJson(response.data);
    } else {
      throw Exception('Something went wrong');
    }
  }

  static logout() async{
    await ApiService.dio!.post('/method/logout');
  }

  static Future getDocinfo(String doctype, String name) async {
    var data = {
      "doctype": doctype,
      "name": name,
    };

    var response = await ApiService.dio!.post(
      '/method/frappe.desk.form.load.get_docinfo',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return Docinfo.fromJson(response.data["docinfo"]);
    } else {
      throw Exception('Something went wrong');
    }
  }

  static Future<List<DoctypeField>> getSessionDefaults() async {
    var response = await ApiService.dio!.get(
      '/method/frappe.core.doctype.session_default_settings.session_default_settings.get_session_default_values',
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200 || response.statusCode ==304 ) {
      List res =json.decode(response.data["message"]);
      return res.map((field) => DoctypeField.fromJson(field)).toList();

    } else {
      throw Exception('Something went wrong');
    }
  }


  static Future<List<DoctypeField>> setSessionDefaults(Map<String,dynamic> data) async {
    data ={'default_values':data};
    var response = await ApiService.dio!.post(
      'method/frappe.core.doctype.session_default_settings.session_default_settings.set_session_default_values',
      data: json.encode(data),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )
          );

    if (response.statusCode == 200) {
      List res =json.decode(response.data["message"]);
      return res.map((field) => DoctypeField.fromJson(field)).toList();

    } else {
      throw Exception('Something went wrong');
    }
  }
}
