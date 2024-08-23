import 'package:be_fit/model/remote/firebase_service/fireStorage/interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../constants/constants.dart';
import '../../../../models/widgets/modules/toast.dart';
import '../errors.dart';

class FireStorageCall extends FireStorageService
{
  @override
  Future<Result<Reference, FirebaseError2>> callFireStorage({
    required String refName,
    required String childName
  })async{

    final connectivityResult = await Connectivity().checkConnectivity();
    switch(connectivityResult) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
        try{
         Reference reference = FirebaseStorage.instance
              .ref(refName)
              .child(childName);

          return Result.success(reference);

        } on FirebaseException catch (e) {
          return Result.error(FirebaseStoreException(e.code));
        }
      default:
        return Result.error(NetworkException('Please Check your connection and try again'));
    }
  }

  @override
  void handleError(BuildContext context, {String? errorMessage}) {
    MyToast.showToast(context, msg: errorMessage??'Try Again Later',color: Constants.appColor);
  }
}