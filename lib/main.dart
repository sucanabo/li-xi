import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lixi/page/main_page.dart';
import 'package:lixi/provider/app_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appProvider = AppProvider()..initState();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => appProvider),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SafeArea(
        child: MainPage(),
      ),
    );
  }
}
