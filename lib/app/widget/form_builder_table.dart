import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:json_table/json_table.dart';

import '../api/frappe_api.dart';
import '../config/frappe_palette.dart';
import '../generic/model/doc_type_response.dart';
import '../modules/form/views/form_view.dart';
import '../utils/form_helper.dart';
import 'frappe_button.dart';
import '../utils/enums.dart' as enums;

class FormBuilderTable<T> extends FormBuilderField<T> {
  FormBuilderTable({
    required String name,
    required BuildContext context,
    required String doctype,
    required T initialValue,
    Key? key,
    FormFieldValidator<T>? validator,
    bool enabled = true,

  }):super(
    name: name,
    key: key,
    validator: validator,
    initialValue: initialValue,
    builder: (FormFieldState field){
      return FutureBuilder(
          future: FrappeAPI.getDoctype(doctype),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var value = (initialValue as List);
              var metaFields =
                  (snapshot.data as DoctypeResponse).docs[0].fields;
              var tableFields = metaFields.where((field) {
                return field.inListView == 1;
              }).toList();
              var selectedRowsIdxs = [];

              var colCount = 3;
              List<JsonTableColumn> columns = [];
              var numFields = [];

              tableFields.forEach(
                    (item) {
                  columns.add(
                    JsonTableColumn(
                      item.fieldname,
                      label: item.label,
                    ),
                  );

                  if (["Float", "Int"].contains(item.fieldtype)) {
                    numFields.add(item.label);
                  }
                },
              );

              colCount =
              columns.length < colCount ? columns.length : colCount;

              if (value.isEmpty) {
                var v = {};

                tableFields.forEach(
                      (tableField) {
                    v[tableField.fieldname] = "";
                  },
                );
                value.add(v);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JsonTable(
                    value,
                    allowRowHighlight: true,
                    rowHighlightColor: FrappePalette.grey[100],
                    // onRowHold: (index) {
                    //   var idx = selectedRowsIdxs.indexOf(index);
                    //   if (idx != -1) {
                    //     selectedRowsIdxs.removeAt(idx);
                    //   } else {
                    //     selectedRowsIdxs.add(index);
                    //   }
                    // },
                    onRowSelect: (index, val) async {
                      var v = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return TableElement(
                              doc: val,
                              fields: tableFields,
                              meta: (snapshot.data as DoctypeResponse)
                                  .docs[0],
                            );
                          },
                        ),
                      ) ??
                          null;

                      if (v != null) {
                        value[index] = v;
                        field.didChange(value);
                      }
                    },

                    columns: columns,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      FrappeFlatButton(
                        onPressed: () {
                          var v = {};
                          tableFields.forEach((tableField) {
                            v[tableField.fieldname] = "";
                          });
                          value.add(v);
                          field.didChange(value);
                        },
                        buttonType: enums.ButtonType.secondary,
                        title: "Add Row",
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      FrappeFlatButton(
                        onPressed: () {
                          selectedRowsIdxs.forEach(
                                (idx) {
                              value.removeAt(idx);
                            },
                          );
                          selectedRowsIdxs.clear();
                          field.didChange(value);
                        },
                        buttonType: enums.ButtonType.secondary,
                        title: "Delete",
                      ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
      );
    }
  );

}


class TableElement extends StatefulWidget {
  final DoctypeDoc meta;
  final List<DoctypeField> fields;
  final Map doc;

  TableElement({
    required this.meta,
    required this.doc,
    required this.fields,
  });

  @override
  _TableElementState createState() => _TableElementState();
}

class _TableElementState extends State<TableElement> {
  final formHelper = FormHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8,
            ),
            child: FrappeFlatButton(
              onPressed: () async {
                if (formHelper.saveAndValidate()) {
                  var formValue = formHelper.getFormValue();
                  Navigator.of(context).pop(formValue);
                }
              },
              buttonType: enums.ButtonType.primary,
              title: "Update",
            ),
          ),
        ],
      ),
      // body: FormView(
      //   fields: widget.meta.fields,
      //   formHelper: formHelper,
      //   doc: widget.doc,
      // ),
    );
  }
}
