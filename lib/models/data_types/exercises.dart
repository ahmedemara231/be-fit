class Exercises
{
  String image;
  String name;
  String docs;
  String id;
  String? muscleName;
  String video;
  bool isCustom;

  Exercises({
    required this.name,
    required this.image,
    required this.docs,
    required this.id,
    this.muscleName,
    required this.isCustom,
    required this.video,
});
}

class CustomExercises extends Exercises
{
  CustomExercises({
    required super.name,
    required super.image,
    required super.docs,
    required super.id,
    required super.isCustom,
    required super.video,
  });
}