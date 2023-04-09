import 'model/doc_type_response.dart';

class ErrorResponse {
  late String? statusMessage;
  late String? userMessage;
  late int? statusCode;
  late String? stackTrace;

  ErrorResponse({
    this.stackTrace,
    this.statusCode,
    this.statusMessage = "Something went wrong",
    this.userMessage,
  });
}

class FieldValue {
  late DoctypeField field;

  late dynamic value;

  FieldValue({
    required this.field,
    this.value,
  });

  FieldValue.fromJson(Map<String, dynamic> json) {
    field = DoctypeField.fromJson(
      json['field'],
    );
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field.toJson();
    data['value'] = this.value;
    return data;
  }
}

typedef OnControlChanged = void Function(
    FieldValue fieldValue,
    );
