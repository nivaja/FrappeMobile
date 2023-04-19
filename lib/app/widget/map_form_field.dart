import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../utils/osm_search.dart';

class FormBuilderMapField extends FormBuilderField<String> {
  FormBuilderMapField({
    required String name,
    required BuildContext context,
    required String initialValue,
    Key? key,
    FormFieldValidator? validator,
    bool enabled = true
  }):
        super(
          name: name,
          key: key,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<String> geoMap){
            return OpenStreetMapSearchAndPick(
              center: LatLong(27.708317, 85.3205817),
              buttonColor: Colors.blue,
              onGetCurrentLocationPressed: () async{
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                return LatLng(position.latitude, position.longitude);
              },
              buttonText: 'Set This Location',
              onPicked: (pickedData) {
                print(pickedData.latLong.latitude);
                print(pickedData.latLong.longitude);
                print(pickedData.address);
                AwesomeDialog(
                    context: context,
                    title: 'You want to choose ${pickedData.address} as Location?',
                    dialogType: DialogType.info,
                    btnCancelOnPress: (){},
                    btnOkOnPress: (){
                      print(geoMap.value);
                      geoMap.didChange(
                        json.encode({
                          "type": "FeatureCollection",
                          "features": [
                            {
                              "type": "Feature",
                              "properties": {},
                              "geometry": {
                                "type": "Point",
                                "coordinates": [pickedData.latLong.latitude, pickedData.latLong.longitude]
                              }
                            }
                          ]

                        })
                      );

                    }

                ).show();

              },


            );
          }

      );




}




