import 'package:books_app/pages/pesquisar.dart';
import 'package:books_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: 'Books App',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}