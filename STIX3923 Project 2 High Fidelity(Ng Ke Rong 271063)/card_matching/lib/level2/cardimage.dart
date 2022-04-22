import 'package:flutter/material.dart';

class Game2 {
  Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  
  final String hiddenCardpath = "assets/images/hidden.png";
  List<String> cards_list = [
    "assets/images/4.jpg",
    "assets/images/4.jpg",
    "assets/images/5.jpg",
    "assets/images/5.jpg",
    "assets/images/6.jpg",
    "assets/images/6.jpg",
  ];
  final int cardCount = 6;
  List<Map<int, String>> matchCheck = [];

  //methods
  void initGame() {
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}