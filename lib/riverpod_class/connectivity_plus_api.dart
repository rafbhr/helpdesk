import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//lets just take 3 cases for now, not including bluetooth etc
enum NetworkStatus { NotDetermined, On, Off }

class NetworkDetectorNotifier extends StateNotifier<NetworkStatus> {

  StreamController<ConnectivityResult> controller = StreamController<ConnectivityResult>();

  NetworkStatus lastResult;

  NetworkDetectorNotifier() : lastResult = NetworkStatus.NotDetermined, super(NetworkStatus.NotDetermined) {

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need
      NetworkStatus newState = NetworkStatus.NotDetermined;

      switch (result) {
        case ConnectivityResult.mobile:
          newState = NetworkStatus.On;
          break;
        case ConnectivityResult.wifi:
          newState = NetworkStatus.On;
          break;
        case ConnectivityResult.none:
          newState = NetworkStatus.Off;
          break;
        case ConnectivityResult.bluetooth:
        // TODO: Handle this case.
          break;
        case ConnectivityResult.ethernet:
        // TODO: Handle this case.
          break;
      }
      if (newState != state) {
        state = newState;
      }
    });
  }
}




final networkAwareProvider = StateNotifierProvider.autoDispose((ref) {
  return NetworkDetectorNotifier();
});
