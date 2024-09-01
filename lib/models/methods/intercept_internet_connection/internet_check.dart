import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class CheckInternetConnection
{
  void startInternetInterceptor(BuildContext context)
  {
    Connectivity connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((newState) {
      switch(newState)
      {
        case ConnectivityResult.none:
          handleNoneConnectionState(context);

        default:
          handleConnectionState(context);
      }
    });

    // Timer(const Duration(seconds: 10), () {startInternetInterceptor(context);});
  }
}

Future<void> handleNoneConnectionState(BuildContext context)async
{
  await FirebaseFirestore.instance.disableNetwork();
  // AnimatedSnackBar.material(
  //     'Please check your internet connection',
  //     type: AnimatedSnackBarType.error,
  //     mobileSnackBarPosition: MobileSnackBarPosition.bottom
  // ).show(context);
}

Future<void> handleConnectionState(BuildContext context)async
{
  await FirebaseFirestore.instance.enableNetwork();
  // AnimatedSnackBar.material(
  //     'Received',
  //     type: AnimatedSnackBarType.success,
  //     mobileSnackBarPosition: MobileSnackBarPosition.bottom
  // ).show(context);
}