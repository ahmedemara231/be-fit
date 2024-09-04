import 'package:cloud_firestore/cloud_firestore.dart';

class CardioRecords
{
  String dateTime;
  String time;

  CardioRecords({
    required this.dateTime,
    required this.time,
});

  factory CardioRecords.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> jsonData)
  {
    return CardioRecords(
        dateTime: jsonData.data()['dateTime'],
        time: jsonData.data()['time']
    );
  }
}