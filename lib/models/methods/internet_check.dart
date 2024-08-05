import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../widgets/modules/snackBar.dart';

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
      if(newState == ConnectivityResult.none)
      {
        MySnackBar.showSnackBar(
            context: context,
            message: 'Please check your internet connection',
            color: Colors.grey
        );
      }
    });
  }
}