import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import './providers/account.dart';

import './pages/landing.dart';
import './pages/login.dart';
import './pages/register.dart';

String Function(BuildContext context, GoRouterState state) redirect = 
  (BuildContext context, GoRouterState state) => 
    context.read<Account>().isAuthenticated ? '/home' : '/auth';

final router = GoRouter(
  // redirect: redirect,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: LandingPage()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => const MaterialPage(child: RegisterPage()),
    ),
  ],  
);