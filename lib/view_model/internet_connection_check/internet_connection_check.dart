import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../modules/snackBar.dart';

abstract class InternetCheck
{
  Future<void> internetCheck(context,{
    required Function validConnectionAction,
    required Function inValidConnectionAction,
  })async {}
}

class FirstCheckMethod implements InternetCheck
{
  FirstCheckMethod._internal();
  static FirstCheckMethod? instance;

  factory FirstCheckMethod.getInstance()
  {
    instance ??= FirstCheckMethod._internal();
    return instance!;
  }

  @override
  Future<void> internetCheck(context, {
    required Function validConnectionAction,
    required Function inValidConnectionAction
  })async
  {
    final connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult == ConnectivityResult.none)
    {
      log('$connectivityResult');
      inValidConnectionAction();
    }
    else
    {
      log('$connectivityResult');
      validConnectionAction();
    }
  }
}

class SecondCheckMethod implements InternetCheck
{
  @override
  Future<void> internetCheck(context, {
    required Function validConnectionAction,
    required Function inValidConnectionAction
  }) async{
      final connectivityResult = await Connectivity().checkConnectivity();
      switch(connectivityResult)
      {
        case ConnectivityResult.mobile:
          log('mobile');
          return;
        case ConnectivityResult.wifi:
          log('wifi');
          return;
        case ConnectivityResult.bluetooth:
          return;
        case ConnectivityResult.ethernet:
          return;
        case ConnectivityResult.vpn:
          return;
        case ConnectivityResult.other:
          return;
        case ConnectivityResult.none:
          MySnackBar.showSnackBar(
              context: context,
              message: 'Check your internet connection and try again',
              color: Colors.red
          );
    }
    throw UnimplementedError();
  }
}

