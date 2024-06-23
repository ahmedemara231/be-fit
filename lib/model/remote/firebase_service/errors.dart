abstract class FirebaseError implements Exception
{
  String? message;
  FirebaseError(this.message);
}

class FirebaseAuthenticationException extends FirebaseError
{
  FirebaseAuthenticationException(super.message);
}

class FirebaseStoreException extends FirebaseError
{
  FirebaseStoreException(super.message);
}

class NetworkException extends FirebaseError
{
  NetworkException(super.message);
}
