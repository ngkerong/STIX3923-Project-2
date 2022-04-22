import 'package:flutter/material.dart';

class Game3 {
  Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  
  final String hiddenCardpath = "assets/images/hidden.png";
  List<String> cards_list = [
    "assets/images/7.png",
    "assets/images/7.png",
    "assets/images/8.jpg",
    "assets/images/8.jpg",
    "assets/images/9.jpg",
    "assets/images/9.jpg",
    "assets/images/10.png",
    "assets/images/10.png",
  ];
  final int cardCount = 8;
  List<Map<int, String>> matchCheck = [];

  //methods
  void initGame() {
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}