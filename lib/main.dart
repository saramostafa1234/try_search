import 'package:flutter/material.dart';
import 'package:try_screen_search/screen_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'search screen',
      home: SearchScreen(),
    );
  }
}

