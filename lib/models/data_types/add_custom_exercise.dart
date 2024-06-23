class AddCustomExerciseModel
{
  String uId;
  String muscle;
  String name;
  String description;

  AddCustomExerciseModel({
    required this.uId,
    required this.muscle,
    required this.name,
    required this.description,
});


  Map<String,dynamic> toJson(String imageUrl)
  {
    return {
      'muscle' : muscle,
      'name' : name,
      'image' : [imageUrl],
      'description' : description,
      'isCustom' : true,
    };
  }
}