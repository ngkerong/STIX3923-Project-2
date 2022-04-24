import 'package:flutter/material.dart';

class Game4 {
  Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  
  final String hiddenCardpath = "assets/images/dots.png";
  List<String> cards_list = [
    "assets/images/11.jpg",
    "assets/images/11.jpg",
    "assets/images/12.jpg",
    "assets/images/12.jpg",
    "assets/images/13.jpg",
    "assets/images/13.jpg",
    "assets/images/14.jpg",
    "assets/images/14.jpg",
  ];
  final int cardCount = 8;
  List<Map<int, String>> matchCheck = [];

  //methods
  void initGame() {
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}