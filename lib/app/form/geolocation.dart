import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frappe_mobile_custom/app/utils/enums.dart';
import 'package:frappe_mobile_custom/app/widget/frappe_button.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frappe_mobile_custom/app/widget/map_form_field.dart';


import '../generic/model/doc_type_response.dart';
import 'package:latlong2/latlong.dart';


class Geolocation extends StatefulWidget {
  final DoctypeField doctypeField;
  final Map? doc;
  const Geolocation({Key? key, required this.doctypeField, this.doc}) : super(key: key);

  @override
  State<Geolocation> createState() => _GeolocationState();
}

class _GeolocationState extends State<Geolocation> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
          height: 500,
          width: 500,
          child: widget.doc?[widget.doctypeField.fieldname] == null ?FormBuilderMapField(
            name: widget.doctypeField.fieldname,
            initialValue: '{}',
            context: context,
          ) :  _loadMap()
      )


    ;
  }

  Future<String> _getAddress (double lat, double log) async{
    List<Placemark> placemarks = await placemarkFromCoordinates(lat,log);
    var address = placemarks.first;
    return '${address.name!}, ${address.thoroughfare}, ${address.subLocality}, ${address.locality}, ${address.administrativeArea}, ${address.country}';
  }

  Widget _loadMap() {
    Map<String,dynamic> geoMap = json.decode(widget.doc![widget.doctypeField.fieldname]) as Map<String,dynamic>;

    var geoCoords= geoMap['features'][0]['geometry']['coordinates'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder<String>(
            future: _getAddress(geoCoords[0], geoCoords[1]),
            builder: (BuildContext context,AsyncSnapshot<String> snapshot) {
              if(snapshot.hasData){
                return Text(snapshot.data!);
              }
              if(snapshot.hasError){
                print(snapshot.error);
                return Text(snapshot.error.toString());
              }
              return const Center(child: CircularProgressIndicator());    }
            ),

        FrappeFlatButton(onPressed: ()async {
            await launchUrl(
              Uri.parse('https://www.google.com/maps/dir//${geoCoords[0]},${geoCoords[1]}'),
              mode: LaunchMode.externalApplication,

            );
        }, buttonType: ButtonType.primary,title: 'Get Direction'),
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(geoCoords[0], geoCoords[1]),
              zoom: 15,
            ),
                  children: [

              TileLayer(
                urlTemplate: "http://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}&s=Ga",
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                      builder: (context)=>const Icon(Icons.location_on,color: Colors.blue,size: 50,),
                      point: LatLng(geoCoords[0], geoCoords[1]),
                      height: 100,
                      width: 100

                  )],
              ),
            ],
          ),
        ),
      ],
    );
  }
}




