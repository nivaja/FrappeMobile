import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frappe_mobile_custom/app/api/ApiService.dart';

import '../generic/common.dart';
import '../generic/model/doc_type_response.dart';
import '../generic/model/get_doc_response.dart';
import '../utils/utils.dart';

class FrappeAPI{
  static Future<DoctypeResponse> getDoctype(String doctype) async {
    var queryParams = {
      'doctype': doctype,
    };

    try {
      final response = await ApiService.dio!.get('/method/frappe.desk.form.load.getdoctype',
        queryParameters: queryParams,
      );

      if (response.statusCode == HttpStatus.ok) {
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
        throw ErrorResponse();
      }
    }
  }

  static Future<Map> searchLink({
    String? doctype,
    String? refDoctype,
    String? txt,
    int? pageLength,
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

    try {
      final response = await ApiService.dio!.post(
        '/method/frappe.desk.search.search_link',
        data: queryParams,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,

        ),
      );
      if (response.statusCode == 200) {
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

      if (response.statusCode == 200) {
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


  static Future<GetDocResponse> cancelDoc(String doctype, String name) async {
    var queryParams = {
      'doctype': doctype,
      'name': name,
    };

    try {
      final response = await ApiService.dio!.get(
        '/method/frappe.desk.form.save.cancel',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
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
        throw e;
      }
    }
  }


  static Future<List> fetchList({
    required String doctype,
    List? fieldnames,
    // required DoctypeDoc meta,
    String? orderBy,
    List? filters,
    int? pageLength,
    int? offset,
  }) async {
    var queryParams = {
      'doctype': doctype,
      'fields': jsonEncode(fieldnames),

    };

    // queryParams['limit_start'] = offset.toString();

    if (filters != null && filters.length != 0) {
      queryParams['filters'] = jsonEncode(filters);
    }

    try {
      final response = await ApiService.dio!.get(
        '/method/frappe.desk.reportview.get',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
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
        throw ErrorResponse();
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
    try {
      final response = await ApiService.dio!.put(
        '/resource/$doctype',
        data: formValue,
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

}
