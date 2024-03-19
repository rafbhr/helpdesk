import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void checkLocationPermission(BuildContext context) async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
    status = await Permission.location.request();
  }

  switch (status) {
    case PermissionStatus.denied:
      print('Location permission is denied');
      break;
    case PermissionStatus.permanentlyDenied:
    // The OS restricts access, for example because of parental controls.
      print('Location permission is permanently denied');
      break;
    case PermissionStatus.restricted:
    // The OS restricts access, for example because of parental controls.
      print('Location permission is restricted');
      break;
    case PermissionStatus.granted:
    // You can request the permission.
      print('Location permission is granted');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool dialogShown = prefs.getBool('dialogShown') ?? false;
      if (!dialogShown) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Refresh App'),
              content: Text('Please refresh the app for changes to take effect.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    prefs.setBool('dialogShown', true);
                  },
                ),
              ],
            );
          },
        );
      }
      break;
    case PermissionStatus.limited:
    // On iOS this means that the permission is granted only once.
      print('Location permission is limited');
      break;
    case PermissionStatus.provisional:
    // On iOS this means that the permission is granted only once.
      print('Location permission is provisional');
      break;
  }
}
