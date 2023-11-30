class Exercises
{
  String image;
  String name;
  String docs;
  String id;
  bool isCustom;

  Exercises({
    required this.name,
    required this.image,
    required this.docs,
    required this.id,
    required this.isCustom,
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
  });
}