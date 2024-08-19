import 'package:cloud_firestore/cloud_firestore.dart';

class Exercises
{
  List image;
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

  factory Exercises.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> element)
  {
    return Exercises(
      name: element.data()['name'],
      image: element.data()['image'],
      docs: element.data()['docs'],
      id: element.id,
      muscleName: element.data()['muscle'],
      isCustom: element.data()['isCustom'],
      video: element.data()['video'],
      reps: element.data()['reps'],
      sets: element.data()['sets'],
    );
  }
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

  factory CustomExercises.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> element)
  {
    return CustomExercises(
      video: element.data()['video']??'',
      name: element.data()['name'],
      image: element.data()['image'],
      docs: element.data()['description'],
      id: element.id,
      isCustom: element.data()['isCustom'],
    );
  }

}