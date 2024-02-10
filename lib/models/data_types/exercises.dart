class Exercises
{
  String image;
  String name;
  String docs;
  String id;
  String? muscleName;
  String video;
  bool isCustom;
  String? reps;
  String? sets;

  Exercises({
    required this.name,
    required this.image,
    required this.docs,
    required this.id,
    this.muscleName,
    required this.isCustom,
    required this.video,
    this.reps,
    this.sets,
});
}

class CustomExercises extends Exercises
{
  CustomExercises({
    super.muscleName,
    required super.name,
    required super.image,
    required super.docs,
    required super.id,
    required super.isCustom,
    required super.video,
  });
}