import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Color1 {
  String getColor = "";

  void setColor() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      getColor = (prefs.getString('colorCode') ?? "Default");
      
  }

  bgm1(){
    switch (getColor) {
      case "Default":
        return 0xFFFFECB3;
        
      case "Blue":
        return 0xFFE1F5FE;
        
      case "Red":
        return 0xFFFFCDD2;
        
    }
     
  }

  appColor() {
    setColor();
    switch (getColor) {
      case "Default":
        return Colors.amber;
        break;
      case "Blue":
        return Colors.blue;
        break;
      case "Red":
        return Colors.red;
        break;
    }
     
  }
}