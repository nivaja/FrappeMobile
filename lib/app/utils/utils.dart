import 'dart:convert';
import 'enums.dart';

DateTime? parseDate(val) {
  if (val == null || val == "") {
    return null;
  } else if (val == "Today") {
    return DateTime.now();
  } else {
    return DateTime.parse(val);
  }
}

String getServerMessage(String serverMsgs) {
  var errorMsgs = json.decode(serverMsgs) as List;
  var errorStr = '';
  errorMsgs.forEach((errorMsg) {
    errorStr += json.decode(errorMsg)["message"];
  });

  return errorStr;
}

List sortBy(List data, String orderBy, Order order) {
  if (order == Order.asc) {
    data.sort((a, b) {
      return a[orderBy].compareTo(b[orderBy]);
    });
  } else {
    data.sort((a, b) {
      return b[orderBy].compareTo(a[orderBy]);
    });
  }

  return data;
}

String toTitleCase(String str) {
  return str
      .replaceAllMapped(
      RegExp(
          r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
          (Match m) =>
      "${m[0]?[0].toUpperCase()}${m[0]?.substring(1).toLowerCase()}")
      .replaceAll(RegExp(r'(_|-)+'), ' ');
}


