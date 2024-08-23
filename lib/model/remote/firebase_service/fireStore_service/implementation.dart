import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/model/remote/firebase_service/errors.dart';
import 'package:be_fit/model/remote/firebase_service/fireStore_service/interface.dart';
import 'package:be_fit/models/widgets/modules/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/src/result.dart';

class FireStoreCall extends FireStoreService
{
  @override
  Future<Result<CollectionReference, FirebaseError2>> callFireStore(String collectionName) async{
    final connectivityResult = await Connectivity().checkConnectivity();
    switch(connectivityResult) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
          CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);
          return Result.success(collection);

      default:
        return Result.error(NetworkException('Please Check your connection and try again'));
    }
  }

  @override
  void handleError(BuildContext context, {String? errorMessage}) {
    MyToast.showToast(
        context,
        msg: errorMessage??'Try Again Later',
        color: Constants.appColor
    );
  }
}