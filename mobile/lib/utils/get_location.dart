import 'package:location/location.dart';

import 'singleton.dart';

class GetLocation {
  static Future<bool> getMyLocation() async {
    final location = Location();
    print('location');
    final hasPermission = await location.hasPermission();
    print('hasPermission $hasPermission');
    final serviceEnabled = await location.serviceEnabled();
    print('serveEnabled $serviceEnabled');

    print('get location');
    if (hasPermission == PermissionStatus.denied) {
      return false;
    } else {
      try {
        final userLocation = await location.getLocation();
        print('userLocation:  $userLocation');
        // print('get my Location $userLocation');
        Singleton.instance.curLat = userLocation.latitude;
        Singleton.instance.curLng = userLocation.longitude;
        return true;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print('catch $e');
        return false;
      }
    }

    // var result  =  location.getLocation().then((LocationData userLocation) {
    //   print('get my Location $userLocation');
    //   Singleton.instance.curLat = userLocation.latitude;
    //   Singleton.instance.curLng = userLocation.longitude;
    //   return true;
    // }).catchError((dynamic error) {
    //   print('get location error $error');

    //   return false;
    // });
  }
}
