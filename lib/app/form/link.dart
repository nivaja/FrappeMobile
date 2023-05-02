import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_mobile_custom/app/api/frappe_api.dart';
import 'package:get/get.dart';
import '../config/frappe_icons.dart';
import '../config/palette.dart';
import '../generic/model/doc_type_response.dart';
import '../modules/form/controllers/new_form_controller.dart';
import '../modules/form/views/new_form_view.dart';
import '../utils/form_helper.dart';
import '../utils/frappe_icon.dart';
import '../widget/form_builder_typeahead.dart';
import 'control.dart';

class LinkField extends StatefulWidget {
  final DoctypeField doctypeField;
  final Map? doc;

  final GlobalKey<FormBuilderState>? key;
  final bool showInputBorder;
  final Function? onSuggestionSelected;
  final Function? noItemsFoundBuilder;
  final Widget? prefixIcon;
  final ItemBuilder? itemBuilder;
  final SuggestionsCallback? suggestionsCallback;
  final AxisDirection direction;
  final TextEditingController? controller;

  LinkField({
    this.key,
    required this.doctypeField,
    this.doc,
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
  _LinkFieldState createState() => _LinkFieldState();
}

class _LinkFieldState extends State<LinkField> with ControlInput {
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

    if (widget.doc != null && widget.doctypeField.setOnlyOnce == 1) {
      enabled = false;
    } else {
      enabled = true;
    }

    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.black),
      child: FormBuilderTypeAhead(
        key: widget.key,
        enabled: enabled,
        controller: widget.controller,
        initialValue: widget.doc != null
            ? widget.doc![widget.doctypeField.fieldname]
            : null,
        direction: AxisDirection.down,
        onSuggestionSelected: (item) {
          var val = item is String
              ? item
              : item is Map
              ? item["value"]
              : null;
          if (widget.onSuggestionSelected != null) {
            widget.onSuggestionSelected!(val);
          }

        },
        validator: FormBuilderValidators.compose(validators),
        decoration: Palette.formFieldDecoration(
          label: widget.doctypeField.label,
          suffixIcon: widget.doc?[widget.doctypeField.fieldname] != null &&
              widget.doc?[widget.doctypeField.fieldname] != ""
              ? IconButton(
            onPressed: () {
              // Get.to(FormView(name: widget.doc![widget.doctypeField.fieldname], docType: widget.doctypeField.options));
              // pushNewScreen(
              //   context,
              //   screen: FormView(
              //       doctype: widget.doctypeField.options,
              //       name: widget.doc![widget.doctypeField.fieldname]),
              // );
            },
            icon: const FrappeIcon(
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
                  doctype: widget.doctypeField.options,
                  txt: lowercaseQuery,
                  refDoctype: widget.doctypeField.parent,
                    filters:jsonDecode(widget.doctypeField.description??"{}")
                );

                return response["results"];

            },

        noItemsFoundBuilder: (context) {
          return TextButton(
            onPressed: () async{
              var docName = await Navigator.push(context, MaterialPageRoute(
                  builder: (context)
                  =>NewFormView(docType: widget.doctypeField.options, formHelper: FormHelper(),getData: true,)
              )
              );
              if (docName != null) {
                setState(() {
                  widget.controller?.text = docName;
                });
              }
              Get.delete<NewFormController>(tag: widget.doctypeField.options);
            }, child: Row(
            children: [
              Icon(Icons.add),
              Text('Add New ${widget.doctypeField.options}')
            ],
          ),
          );
        },

      ),
    );
  }
}
