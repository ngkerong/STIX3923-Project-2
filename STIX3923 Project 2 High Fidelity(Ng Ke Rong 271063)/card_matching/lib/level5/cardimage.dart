import 'package:flutter/material.dart';

class Game5 {
  Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  
  final String hiddenCardpath = "assets/images/dots.png";
  List<String> cards_list = [
    "assets/images/15.jpg",
    "assets/images/15.jpg",
    "assets/images/16.jpg",
    "assets/images/16.jpg",
    "assets/images/17.jpg",
    "assets/images/17.jpg",
    "assets/images/18.jpg",
    "assets/images/18.jpg",
    "assets/images/19.jpg",
    "assets/images/19.jpg",
    "assets/images/20.jpg",
    "assets/images/20.jpg",
    "assets/images/26.jpg",
    "assets/images/26.jpg",
    "assets/images/27.jpg",
    "assets/images/27.jpg",
  ];
  final int cardCount = 16;
  List<Map<int, String>> matchCheck = [];

  //methods
  void initGame() {
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}