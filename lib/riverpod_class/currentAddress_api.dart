import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../riverpod_model/address.dart';
import 'currentLocation_api.dart';

//we will create a provider to consume our currentlocationfutureprovider
final currentaddressFutureProvider = FutureProvider<List<Placemark>>((ref) async {
  //we use ref.watch to listen to another provider, and we passed it to the
  //provider that we want to consume Here:currentlocationFutureprovider

  double latitude;
  double longitude;



  void _getGeoLocatorPermission() async {
    bool permissionGranted;

    if (await Permission.location.request().isGranted) {
      permissionGranted = true;
    } else if (await Permission.location.request().isPermanentlyDenied) {
      throw('location.request().isPermanentlyDenied');
    } else if (await Permission.location.request().isDenied) {
      permissionGranted = false;
      throw('location.request().isDenied');
    }   
  }

  /*
    void getGeoLocatorPermission() async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    print(permission);
  }
  */

  try{
    _getGeoLocatorPermission();
    //bool serviceEnabledLocation;
    //serviceEnabledLocation = await Geolocator.isLocationServiceEnabled();
  //if(serviceEnabledLocation == true){
    final currentlocation = await ref.watch(currentlocationFutureProvider.future);
    latitude = currentlocation.latitude;
    longitude = currentlocation.longitude;
    return fetchCurrentAddress(latitude, longitude);
  //}
  }
  catch (e)
  {
    return Future.error(e);
  }
  
});

Future<List<Placemark>> fetchCurrentAddress(latitude, longitude) async {
  List <Placemark> placemark = await placemarkFromCoordinates(latitude, longitude);
  return placemark;
}

