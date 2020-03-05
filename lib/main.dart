import 'package:flutter/material.dart';
import 'ui/home-page.dart';
import 'ui/gif-page.dart';

void main(){
  runApp(
    MaterialApp(
      title: 'Buscador de Gifs',
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.white,
      )
    ),
  );
}
