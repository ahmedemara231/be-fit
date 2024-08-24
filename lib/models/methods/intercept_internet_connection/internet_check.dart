import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../widgets/modules/snackBar.dart';

class CheckInternetConnection
{
  static CheckInternetConnection? checkInternetConnection;

  static CheckInternetConnection getInstance()
  {
    return checkInternetConnection ??= CheckInternetConnection();
  }

  void startInternetInterceptor(context)
  {
    Connectivity connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((newState) {
      if(newState.contains(ConnectivityResult.none))
      {
        FirebaseFirestore.instance.disableNetwork();
        AnimatedSnackBar.material(
            'Please check your internet connection',
            type: AnimatedSnackBarType.error,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom
        ).show(context);
      }
      else{
        FirebaseFirestore.instance.enableNetwork();

        AnimatedSnackBar.material(
            'Please check your internet connection',
            type: AnimatedSnackBarType.error,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom
        ).show(context);

        MySnackBar.showSnackBar(
            context: context,
            message: 'Received',
            color: Colors.grey
        );
      }
    });
  }
}