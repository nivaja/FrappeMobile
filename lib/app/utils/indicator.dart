import 'package:flutter/material.dart';

import '../config/palette.dart';

class Indicator {
  static Widget buildStatusButton(List statuses) {
    String status = _getStatus(statuses);
    if (["Pending", "Review", "Medium", "Not Approved","Partly Paid","Unpaid","Not Saved"]
        .contains(status)) {
      return indicateWarning(status);
    } else if (["Open", "Urgent", "High", "Failed", "Rejected", "Error","Overdue","Cancelled","Draft"]
        .contains(status)) {
      return indicateDanger(status);
    } else if ([
      "Closed",
      "Finished",
      "Converted",
      "Completed",
      "Complete",
      "Confirmed",
      "Approved",
      "Yes",
      "Active",
      "Available",
      "Paid",
      "Success",
    ].contains(status)) {
      return indicateSuccess(status);
    } else if (["Submitted", "Enabled"].contains(status)) {
      return indicateComplete(status);
    } else {
      return indicateUndefined(status);
    }
  }

  static Widget buildIndicator(String title, Map<String, Color> color) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 60,
        ),
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color['bgColor'],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: color['txtColor'],
                fontSize: 12,
              ),
            ),
          ),
        ));
  }

  static Widget indicateDanger(String title) {
    return buildIndicator(
      title,
      {
        'txtColor': Palette.dangerTxtColor,
        'bgColor': Palette.dangerBgColor,
      },
    );
  }

  static Widget indicateSuccess(String title) {
    return buildIndicator(
      title,
      {
        'txtColor': Palette.successTxtColor,
        'bgColor': Palette.successBgColor,
      },
    );
  }

  static Widget indicateWarning(String title) {
    return buildIndicator(
      title,
      {
        'txtColor': Palette.warningTxtColor,
        'bgColor': Palette.warningBgColor,
      },
    );
  }

  static Widget indicateComplete(String title) {
    return buildIndicator(
      title,
      {
        'txtColor': Palette.completeTxtColor,
        'bgColor': Palette.completeBgColor,
      },
    );
  }

  static Widget indicateUndefined(String title) {
    return buildIndicator(
      title,
      {
        'txtColor': Palette.undefinedTxtColor,
        'bgColor': Palette.undefinedBgColor,
      },
    );
  }
}

String _getStatus(List statuses) {
  if(statuses[1] != null){
    return statuses[1];
  }
  return statuses[0]==1 ? "Disabled":"Enabled";
}