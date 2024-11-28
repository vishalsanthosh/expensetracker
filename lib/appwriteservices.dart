import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class Appwriteservices {
  late Client client;

  late Databases databases;

  static const endpoint = "https://cloud.appwrite.io/v1";
  static const projectId = '67480ad800358a962440';
  static const databaseId = '67480b2b002405784bfe';
  static const collectionId = '67480b3f002c9503cd01';

  Appwriteservices() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }
  Future<List<Document>> getExpns() async {
    try {
      final result = await databases.listDocuments(
        collectionId: collectionId,
        databaseId: databaseId,
      );
      return result.documents;
    } catch (e) {
      print('Error loading data: $e');
      rethrow;
    }
  }

  Future<Document> addExpns(String title, String amount, String date) async {
    try {
      final documentId = ID.unique();

      final result = await databases.createDocument(
        collectionId: collectionId,
        databaseId: databaseId,
        data: {
          'title': title,
          'amount': amount,
          'date': date,
        },
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print('Error creating data: $e');
      rethrow;
    }
  }

  Future<void> deleteExpns(String documentId) async {
    try {
      await databases.deleteDocument(
        collectionId: collectionId,
        documentId: documentId,
        databaseId: databaseId,
      );
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}
