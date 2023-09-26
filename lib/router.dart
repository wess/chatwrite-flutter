import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import './providers/account.dart';

String Function(BuildContext context, GoRouterState state) redirect = 
  (BuildContext context, GoRouterState state) => 
    context.read<Account>().isAuthenticated ? '/home' : '/auth';

final router = GoRouter(
  redirect: redirect,
  initialLocation: '/',
  routes: [
  ],  
);