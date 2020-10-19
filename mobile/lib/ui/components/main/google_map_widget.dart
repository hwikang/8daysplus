import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/singleton.dart';

class GoogleMapMarkerWidget extends StatelessWidget {
  const GoogleMapMarkerWidget({
    this.productList,
  });

  final List<ProductListViewModel> productList;

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{};
    final locations = <LatLng>[];
    productList.map((list) {
      if (list.lat == 0.0 || list.lat == null) {
      } else {
        locations.add(LatLng(list.lat, list.lng));
        markers.add(Marker(
            infoWindow: InfoWindow(
              title: list.name,
            ),
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId('marker${list.id}'),
            position: LatLng(list.lat, list.lng)));
      }
    }).toList();

    if (locations.isEmpty) {
      return Container(
        height: 0.0,
      );
    } else {
      return Container(
          height: 201,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(Singleton.instance.curLat, Singleton.instance.curLng),
              zoom: 12,
            ),
            markers: Set<Marker>.of(markers),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
          ));
    }
  }
}
