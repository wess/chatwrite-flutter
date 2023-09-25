import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import './env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client();
  
  client
  .setEndpoint(Env.endpoint)
  .setProject(Env.project);


  runApp(const Main());
}

