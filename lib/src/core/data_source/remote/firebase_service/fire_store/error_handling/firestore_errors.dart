import '../../error_handling/base_error.dart';

class ErrorCode
{
  static const String unavailable = 'No internet connection, please try again later';
  static const String permissionDenied = 'You do not have permission to perform this operation';
  static const String resourceExhausted = 'please try again later';
  static const String aborted = 'Operation aborted, please try again.';
  static const String defaultError = 'can\'t make changes, please try again later';
}


class Unavailable extends FirebaseError
{
  Unavailable(super.message);
}

class PermissionDenied extends FirebaseError
{
  PermissionDenied(super.message);
}

class ResourceExhausted extends FirebaseError
{
  ResourceExhausted(super.message);
}

class Aborted extends FirebaseError
{
  Aborted(super.message);
}

class DefaultError extends FirebaseError
{
  DefaultError(super.message);
}