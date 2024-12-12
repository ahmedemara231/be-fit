import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  static Future<File?> selectImage(ImageSource source)async {
    XFile? image = await ImagePicker().pickImage(source: source);
    if(image == null) {
      throw Exception('No Image Selected');
    }
    return File(image.path);
  }
}