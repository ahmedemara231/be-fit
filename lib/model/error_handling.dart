import 'package:be_fit/models/widgets/modules/snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ErrorCode
{
  static const String unavailable = 'No internet connection, please try again later';
  static const String permissionDenied = 'You do not have permission to perform this operation';
  static const String resourceExhausted = 'please try again later';
  static const String aborted = 'Operation aborted, please try again.';
  static const String defaultError = 'can\'t make changes, please try again later';
}

abstract class NewFirebaseError
{
  String message;
  NewFirebaseError(this.message);
}

class Unavailable extends NewFirebaseError
{
  Unavailable(super.message);
}

class PermissionDenied extends NewFirebaseError
{
  PermissionDenied(super.message);
}

class ResourceExhausted extends NewFirebaseError
{
  ResourceExhausted(super.message);
}

class Aborted extends NewFirebaseError
{
  Aborted(super.message);
}

class DefaultError extends NewFirebaseError
{
  DefaultError(super.message);
}

class ErrorHandler
{

  static ErrorHandler? errorHandler;
  ErrorHandler();

  static ErrorHandler getInstance()
  {
    return errorHandler ??= ErrorHandler();
  }


  NewFirebaseError handleFireStoreError(BuildContext context,FirebaseException e) {
    switch (e.code) {
      case 'unavailable':
        _showErrorMessage(context, ErrorCode.unavailable);
        return Unavailable(ErrorCode.unavailable);

      case 'permission-denied':
        _showErrorMessage(context, ErrorCode.permissionDenied);
        return PermissionDenied(ErrorCode.permissionDenied);

      case 'resource-exhausted':
        _showErrorMessage(context, ErrorCode.resourceExhausted);
        return ResourceExhausted(ErrorCode.resourceExhausted);

      case 'aborted':
        _showErrorMessage(context, ErrorCode.aborted);
        return Aborted(ErrorCode.aborted);

      default:
        _showErrorMessage(context, ErrorCode.defaultError);
        return DefaultError(ErrorCode.defaultError);
    }
  }

  void _showErrorMessage(BuildContext context, String message)
  {
    MySnackBar.showSnackBar(context: context, message: message);
  }
}