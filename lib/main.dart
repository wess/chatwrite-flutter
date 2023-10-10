import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart' show Client;

import 'env.dart';
import 'app.dart';

import 'providers/account.dart';
import 'providers/chat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client();
  
  client
  .setEndpoint(Env.endpoint)
  .setProject(Env.project)
  .setSelfSigned(status: true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Account>(create: (context) => Account(client)),
        ChangeNotifierProvider<Chat>(create: (context) => Chat(client))
      ],
      child: const App()
    )
  );
}
