import 'package:flutter/material.dart';

import 'json_table.dart';
import 'json_utilities.dart';
import 'json_table.dart';
import 'json_table_column.dart';

class TableColumn extends StatelessWidget {
  final String? header;
  final int headerIndex;
  final List? dataList;
  final TableHeaderBuilder? tableHeaderBuilder;
  final TableCellBuilder? tableCellBuilder;
  final JsonTableColumn? column;
  final jsonUtils = JSONUtils();
  final Function(int index, dynamic rowMap) onRowTap;
  final List<int>? selectedRowIndexes;
  final bool allowRowHighlight;
  final Color? rowHighlightColor;
  final Function(int index) onRowHold;

  TableColumn(
      this.header,
      this.headerIndex,
      this.dataList,
      this.tableHeaderBuilder,
      this.tableCellBuilder,
      this.column,
      this.onRowTap,
      this.selectedRowIndexes,
      this.allowRowHighlight,
      this.rowHighlightColor,
      this.onRowHold);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          tableHeaderBuilder != null
              ? tableHeaderBuilder!(header, headerIndex)
              : Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5),
              color: Colors.grey[300],
            ),
            child: Text(
              header!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            child: Column(
              children: dataList!
                  .asMap()
                  .entries
                  .map(
                    (entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        onRowTap(entry.key, entry.value);
                      },
                      onLongPress: () {
                        onRowHold(entry.key);
                      },
                      child: Container(
                        color: (allowRowHighlight &&
                            selectedRowIndexes != null &&
                            selectedRowIndexes!.indexOf(entry.key) !=
                                -1)
                            ? rowHighlightColor ??
                            Colors.yellowAccent.withOpacity(0.7)
                            : null,
                        child: tableCellBuilder != null
                            ? tableCellBuilder!(
                            getFormattedValue(
                              jsonUtils.get(
                                entry.value,
                                column?.field ?? header!,
                                column?.defaultValue ?? '',
                              ),
                            ),
                            [entry.key, headerIndex])
                            : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.grey.withOpacity(0.5),
                              )),
                          child: Text(
                            getFormattedValue(
                              jsonUtils.get(
                                entry.value,
                                column?.field ?? header!,
                                column?.defaultValue ?? '',
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  String getFormattedValue(dynamic value) {
    if (value == null) return column?.defaultValue ?? '';
    if (column?.valueBuilder != null) {
      return column!.valueBuilder!(value);
    }
    return value.toString();
  }
}
