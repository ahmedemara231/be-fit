abstract class FirebaseError implements Exception
{
  final String message;

  FirebaseError(this.message);
}

class NetworkError extends FirebaseError
{
  NetworkError(super.message);
}
