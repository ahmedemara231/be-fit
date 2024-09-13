abstract class SecondFirebaseError implements Exception
{
  String? message;
  SecondFirebaseError(this.message);
}

class FirebaseAuthenticationException extends SecondFirebaseError
{
  FirebaseAuthenticationException(super.message);
}

class NetworkException extends SecondFirebaseError
{
  NetworkException(super.message);
}