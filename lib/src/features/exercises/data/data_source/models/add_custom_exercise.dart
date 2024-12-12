import 'dart:io';

class AddCustomExerciseModel
{
  String muscle;
  String name;
  String description;


  AddCustomExerciseModel({
    required this.muscle,
    required this.name,
    required this.description,
  });


  Map<String,dynamic> toJson(String imageUrl)
  {
    return {
      'muscle' : muscle,
      'image' : [imageUrl],
      'name' : name,
      'description' : description,
      'isCustom' : true,
    };
  }
}

class FireStorageInputs
{
  String refName;
  String childName;
  File selectedExerciseImage;

  FireStorageInputs({
    required this.refName,
    required this.childName,
    required this.selectedExerciseImage,
  });
}