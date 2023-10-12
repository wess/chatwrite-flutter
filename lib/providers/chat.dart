import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart' as Appwrite;
import 'package:appwrite/models.dart' show DocumentList;

import '../env.dart';

class Message {
  final String user;
  final String message;

  Message({required this.user, required this.message});
}

class Chat extends ChangeNotifier {
  final Appwrite.Databases _databases;
  final Appwrite.Realtime _realtime;
  Appwrite.RealtimeSubscription? _subscription;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  Chat(Appwrite.Client client):
    _databases = Appwrite.Databases(client),
    _realtime = Appwrite.Realtime(client) {
      _subscription = _realtime.subscribe([
        "documents"
      ]);

      _subscription?.stream.listen((event) {
        list();
      });
    }

  Future<void> send(Message message) async {
    try {
      await _databases.createDocument(
        databaseId: Env.database,
        collectionId: Env.collectionMessage,
        documentId: Appwrite.ID.unique(),
        data: {
          'user': message.user,
          'message': message.message,
        }
      );
    } catch(e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> list() async {
    try {
      final DocumentList response = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: Env.collectionMessage,
        queries: [
          Appwrite.Query.limit(100),
          Appwrite.Query.orderAsc('created'),
          Appwrite.Query.offset(_messages.length)
        ]
      );

      final List<Message> incoming = response.documents.map<Message>((message) {
        return Message(
          user: message.data['user'],
          message: message.data['message']
        );
      }).toList();

      _messages.addAll(incoming);

      notifyListeners();

    } catch(e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}