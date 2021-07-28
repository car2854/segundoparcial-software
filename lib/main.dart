import 'package:flutter/material.dart';
import 'package:proyecto/pages/index.dart';
import 'package:proyecto/pages/login.dart';
import 'package:proyecto/pages/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: 'login',

      routes: {
        'login'     : (_) => LoginPage(),
        'register'  : (_) => RegisterPage(),
        'index'     : (_) => IndexPage(),
      },
    );
  }
}
