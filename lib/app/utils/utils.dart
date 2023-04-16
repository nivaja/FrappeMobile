import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '../generic/common.dart';

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


