import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageSelector
{
  Future<File?> selectImage(ImageSource source)async
  {
    ImagePicker picker = ImagePicker();

    XFile? image = await picker.pickImage(source: source);
    if(image == null)
    {
      return null;
    }
    else{
      return File(image.path);
    }
  }
}