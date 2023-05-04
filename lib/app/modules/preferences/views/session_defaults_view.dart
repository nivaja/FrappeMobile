import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frappe_mobile_custom/app/api/frappe_api.dart';
import 'package:frappe_mobile_custom/app/generic/model/doc_type_response.dart';
import 'package:frappe_mobile_custom/app/modules/form/views/just_form_view.dart';
import 'package:frappe_mobile_custom/app/utils/enums.dart';
import 'package:frappe_mobile_custom/app/utils/form_helper.dart';
import 'package:frappe_mobile_custom/app/utils/frappe_alert.dart';
import 'package:frappe_mobile_custom/app/widget/app_bar.dart';
import 'package:frappe_mobile_custom/app/widget/frappe_button.dart';

import '../../../config/config.dart';

class SessionDefaultsView extends StatelessWidget {
  const SessionDefaultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formHelper = FormHelper();
    return Scaffold(
      appBar: appBar(title: 'Session Defaults',
      actions:[
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical:12,
            horizontal: 8,
          ),
          child: FrappeFlatButton(
              onPressed: () async{
            try {
              EasyLoading.show(
                maskType: EasyLoadingMaskType.black,
                indicator: const CircularProgressIndicator(backgroundColor: Colors.white),
                status: 'Please Wait...',);
              formHelper.save();
              await FrappeAPI.setSessionDefaults(formHelper.getFormValue());
              FrappeAlert.successAlert(title: 'Defaults Saved');
            }
            catch (e){
              FrappeAlert.errorAlert(title: 'Something Went Wrong');
            }
            finally {
              EasyLoading.dismiss();
            }
          }, buttonType: ButtonType.primary, title: 'save'),
        )
      ]
      ),
      body: FutureBuilder<List<DoctypeField>>(
        future: FrappeAPI.getSessionDefaults(),
        builder: (context,snapshot) {
          if(snapshot.hasData){
            return JustFormView(
              onlyAllowedInQuickEntry: false,
              formHelper: formHelper,
              doc: Map.fromIterable(snapshot.data!,
                key: (item) => item.fieldname,
                value: (item) => item.defaultValue,
              ),
              fields: snapshot.data!,
            );
          }else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          return const Center(child: CircularProgressIndicator());
        }

      ),
    );
  }
}
