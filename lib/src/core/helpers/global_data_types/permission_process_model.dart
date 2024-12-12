enum PermissionClient {camera, storage, contacts, notification}

class PermissionProcessModel
{
  PermissionClient permissionClient;
  Function() onPermissionGranted;
  Function() onPermissionDenied;

  PermissionProcessModel({
    required this.permissionClient,
    required this.onPermissionGranted,
    required this.onPermissionDenied,
  });
}