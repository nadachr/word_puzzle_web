import 'dart:convert';

import 'package:word_puzzle_english/pages/game_page.dart';
import 'package:word_puzzle_english/utilities/my_constant.dart';
import 'package:word_puzzle_english/utilities/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: Container(
        width: double.infinity,
        color: MyColors.primary,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      color: MyColors.primary,
                      height: constraints.maxHeight,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: size.width * 0.35,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 10),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 15),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3.0,
                                  horizontal: 15.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: MyColors.secondary,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(10, 10),
                                      blurRadius: 10,
                                      spreadRadius: -5,
                                      color: MyColors.grey.withOpacity(0.4),
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  child: Text(
                                    'PLAY!',
                                    style: GoogleFonts.chakraPetch(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: MyColors.primary,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GameScreen()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        height: 90,
        child: Column(
          children: [
            Text(
              'Nada Chemreh 161404140022',
              style: GoogleFonts.chakraPetch(
                fontSize: 18,
                letterSpacing: 3,
                color: MyColors.secondary,
              ),
            ),
            Text(
              'Bunyarit Thongsuk 161404140024',
              style: GoogleFonts.chakraPetch(
                fontSize: 18,
                letterSpacing: 3,
                color: MyColors.secondary,
              ),
            ),
            Text(
              '- Computer Engineering -',
              style: GoogleFonts.chakraPetch(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: MyColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
