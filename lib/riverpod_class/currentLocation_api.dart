import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/* statenotifier is something like, if we click on pressed, then we call futureprovider inside here.
class LocationApi extends ChangeNotifier{
  List<Address> places = [];  
}
*/
//get currentlocation position, can be used for itself or can be iniside current_address too. multiPurpose.
final currentlocationFutureProvider = FutureProvider<Position>((ref) => fetchCurrentLocation());
Future<Position> fetchCurrentLocation() async {

  try{
  Position currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  return currentLocation;
  }
  catch (e){
    return Future.error(e);
  }
}

final lastknownlocationFutureProvider = FutureProvider<Position>((ref) => fetchLastKnownLocation());
Future<Position> fetchLastKnownLocation() async {
  Position? lastKnownLocation = await Geolocator.getLastKnownPosition();
  if (lastKnownLocation == null) {
    // Provide a default Position here if lastKnownLocation is null
    return Position(
        latitude: 0,
        longitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0
    );
  }
  return lastKnownLocation;
}

