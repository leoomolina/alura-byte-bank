import 'package:bytebank/screens/counter.dart';
import 'package:flutter/material.dart';
import '../screens/dashboard.dart';

final byteBankTheme = MaterialApp(
  home: CounterContainer(),
  theme: ThemeData(
    primaryColor: Colors.green[900],
    buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent[700],
        textTheme: ButtonTextTheme.primary),
  ),
  debugShowCheckedModeBanner: true,
);
