import 'dart:async';
import 'dart:convert';

import 'package:word_puzzle_english/pages/home_page.dart';
import 'package:word_puzzle_english/pages/game_page.dart';
import 'package:word_puzzle_english/utilities/my_constant.dart';
import 'package:word_puzzle_english/utilities/my_dialog.dart';
import 'package:word_puzzle_english/utilities/my_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Word Puzzle',
      theme: ThemeData(
        primaryColor: MyColors.primary,
        secondaryHeaderColor: MyColors.secondary,
      ),
      home: HomeScreen(),
    );
  }
}
