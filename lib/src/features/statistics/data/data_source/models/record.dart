import 'package:cloud_firestore/cloud_firestore.dart';

class MyRecord {
  var reps;
  var weight;

  MyRecord({
    required this.reps,
    required this.weight,
  });

  factory MyRecord.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> jsonRecord)
  {
    return MyRecord(
        reps: jsonRecord.data()['reps'],
        weight: jsonRecord.data()['weight']
    );
  }
}