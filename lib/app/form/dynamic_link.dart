import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_mobile_custom/app/api/frappe_api.dart';


import '../config/frappe_icons.dart';
import '../config/palette.dart';
import '../generic/model/doc_type_response.dart';
import '../utils/frappe_icon.dart';
import '../widget/form_builder_typeahead.dart';
import 'control.dart';

class DynamicLink extends StatefulWidget {
  final DoctypeField doctypeField;
  final Map doc;

  final key;
  final bool showInputBorder;
  final Function? onSuggestionSelected;
  final Function? noItemsFoundBuilder;
  final Widget? prefixIcon;
  final ItemBuilder? itemBuilder;
  final SuggestionsCallback? suggestionsCallback;
  final AxisDirection direction;
  final TextEditingController? controller;

  DynamicLink({
    this.key,
    required this.doctypeField,
    required this.doc,
    this.prefixIcon,
    this.onSuggestionSelected,
    this.noItemsFoundBuilder,
    this.showInputBorder = false,
    this.itemBuilder,
    this.suggestionsCallback,
    this.controller,
    this.direction = AxisDirection.down,
  });

  @override
  _DynamicLinkState createState() => _DynamicLinkState();
}

class _DynamicLinkState extends State<DynamicLink> with ControlInput {
  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];
    var f = setMandatory(widget.doctypeField);
    late bool enabled;

    if (f != null) {
      validators.add(
        f(context),
      );
    }

    // if (widget.doctypeField.readOnly == 1 ||
    //     (widget.doc != null && widget.doctypeField.setOnlyOnce == 1)) {
    //   enabled = false;
    // } else {
    //   enabled = true;
    // }

    if ((widget.doc[widget.doctypeField.fieldname] != null &&
        widget.doctypeField.setOnlyOnce == 1) ||
        widget.doctypeField.readOnly == 1) {
      enabled = false;
    } else {
      enabled = true;
    }

    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.black),
      child: FormBuilderTypeAhead(
        key: widget.key,
        enabled: enabled,
        onChanged: (val) {
          // if (widget.onControlChanged != null) {
          //   widget.onControlChanged!(
          //     FieldValue(
          //       field: widget.doctypeField,
          //       value: val,
          //     ),
          //   );
          // }
        },
        controller: widget.controller,
        initialValue: widget.doc[widget.doctypeField.fieldname],
        direction: AxisDirection.up,
        onSuggestionSelected: (item) {
          if (widget.onSuggestionSelected != null) {
            if (item is String) {
              widget.onSuggestionSelected!(item);
            } else if (item is Map) {
              widget.onSuggestionSelected!(item["value"]);
            }
          }
        },
        validator: FormBuilderValidators.compose(validators),
        decoration: Palette.formFieldDecoration(
          label: widget.doctypeField.label,
          suffixIcon: widget.doc[widget.doctypeField.fieldname] != null &&
              widget.doc[widget.doctypeField.fieldname] != ""
              ? IconButton(
            onPressed: () {
              // pushNewScreen(
              //   context,
              //   screen: FormView(
              //       doctype: widget.doc[widget.doctypeField.options],
              //       name: widget.doc[widget.doctypeField.fieldname]),
              // );
            },
            icon: FrappeIcon(
              FrappeIcons.arrow_right_2,
              size: 14,
            ),
          )
              : null,
        ),
        selectionToTextTransformer: (item) {
          if (item != null) {
            if (item is Map) {
              return item["value"];
            }
          }
          return item.toString();
        },
        name: widget.doctypeField.fieldname,
        itemBuilder: widget.itemBuilder ??
                (context, item) {
              if (item is Map) {
                return ListTile(
                  title: Text(
                    item["value"],
                  ),
                  subtitle: item["description"] != null
                      ? Text(
                    item["description"],
                  )
                      : null,
                );
              } else {
                return ListTile(
                  title: Text(item.toString()),
                );
              }
            },
        suggestionsCallback: widget.suggestionsCallback ??
                (query) async {
              var lowercaseQuery = query.toLowerCase();

              var response = await FrappeAPI.searchLink(
                doctype: widget.doc[widget.doctypeField.options],
                txt: lowercaseQuery,
                refDoctype:widget.doctypeField.parent,
                filters:jsonDecode(widget.doctypeField.description??"{}")
              );

              return response["results"];
            },
        noItemsFoundBuilder: (context) {
          return TextButton(onPressed: () {},
              child: Row(children: const [Icon(Icons.add), Text('Add New')],));
        },
      ),
    );
  }
}
