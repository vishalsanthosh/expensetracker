import 'package:appwrite/models.dart';

class Note {
  final String id;
  final String title;
  final String amount;
  final String date;

  Note(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});
  factory Note.fromDocument(Document doc) {
    return Note(
        id: doc.$id,
        title: doc.data["title"],
        amount: doc.data["amount"],
        date: doc.data["date"]);
  }
}
