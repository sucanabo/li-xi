import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lixi/page/main_page.dart';
import 'package:lixi/provider/app_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppProvider()),
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
          ),
        ),
      ),
      home: const SafeArea(
        child: MainPage(),
      ),
    );
  }
}
