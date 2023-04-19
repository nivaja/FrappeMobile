import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

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
          ) : _loadMap()
      )


    ;
  }

  Widget _loadMap() {
    Map<String,dynamic> geoMap = json.decode(widget.doc![widget.doctypeField.fieldname]) as Map<String,dynamic>;

    var geoCoords= geoMap['features'][0]['geometry']['coordinates'];
    return FlutterMap(
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
                builder: (context)=>Icon(Icons.location_on,color: Colors.blue,size: 50,),
                point: LatLng(geoCoords[0], geoCoords[1]),
                height: 100,
                width: 100

            )],
        ),
      ],
    );
  }
}




