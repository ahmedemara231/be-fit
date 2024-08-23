abstract class FirebaseError2 implements Exception
{
  String? message;
  FirebaseError2(this.message);
}

class FirebaseAuthenticationException extends FirebaseError2
{
  FirebaseAuthenticationException(super.message);
}

class FirebaseStoreException extends FirebaseError2
{
  FirebaseStoreException(super.message);
}

class NetworkException extends FirebaseError2
{
  NetworkException(super.message);
}
