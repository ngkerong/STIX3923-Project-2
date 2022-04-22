import 'package:flutter/material.dart';


class GameEx {
  Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  
  List<NetworkImage>cards_list =[];

  final String hiddenCardpath = "assets/images/hidden.png";
  

  List<Map<int, String>> matchCheck = [];


  //methods
  void initGame() {
    
    gameColors = List.generate(cards_list.length, (index) => hiddenCard);
    gameImg = List.generate(cards_list.length, (index) => hiddenCardpath);
  }

  

}