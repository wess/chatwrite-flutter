import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final Router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) => context.read<Auth>().user == null ? '/login' : '/home',
  initialLocation: '/',
  routes: [

  ],  
);