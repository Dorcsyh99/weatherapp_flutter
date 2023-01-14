// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_world_time_whether/pages/choose_location.dart';
import 'package:flutter_world_time_whether/pages/home.dart';
import 'package:flutter_world_time_whether/pages/loading.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/':(context) => Loading(),
      '/home': (context) => Home(),
      '/location':(context) => ChooseLocation(),
    },
    theme: ThemeData(fontFamily: 'Jura'),
  ));
}


