import 'package:permission_handler/permission_handler.dart';
import '../data_types/permission_process_model.dart';

late Permission permission;

Future<void> checkPermission(PermissionProcessModel processModel)async
{
  switch(processModel.permissionClient)
  {
    case PermissionClient.camera:
      permission = Permission.camera;

    case PermissionClient.storage:
      permission = Permission.storage;

    case PermissionClient.contacts:
      permission = Permission.contacts;

    case PermissionClient.notification:
      permission = Permission.notification;

    default:
      return;
  }

  await askForPermission(
      onPermissionGranted: processModel.onPermissionGranted,
      onPermissionDenied: processModel.onPermissionDenied
  );
}

Future<void> askForPermission({
  required Function() onPermissionGranted,
  required Function() onPermissionDenied,
})async
{
  bool status = await permission.status.isGranted;
  if(!status)
  {
    PermissionStatus status = await permission.request();
    switch(status)
    {
      case PermissionStatus.granted:
        onPermissionGranted();
      default:
        onPermissionDenied();
    }
  }
  else{
    onPermissionGranted();
  }
}
