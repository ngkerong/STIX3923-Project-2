import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';  
import 'package:shared_preferences/shared_preferences.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();

}

class SettingPageState extends State<SettingPage>{

  late double screenHeight, screenWidth;

  bool audio = true;
  String latestCol = " ";
  String selectCol = " ";
  String lang1 = " ";
  String lang2 = " ";
  String lang3 = " ";
  String lang4 = " ";
  String selectedLang = " ";
  List<String> colorlist = [
     "Default",
     "Blue",
     "Red",
   ];
  List<String> langlist = [
     "English",
     "Malay",
   ];
  Color color1 = Color(0xFFFFECB3);
  Color color2 = Color(0xFFE1F5FE);
  Color color3=  Color(0xFFFFCDD2); 
  String valueString =" ";
  int value = 0;
  Color otherColor = Color(0x00000000);


  void initState(){
    super.initState();
    setState((){
      loadColor();
      loadLanguage();
    });
  }

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectCol = (prefs.getString('colorCode') ?? "Default");
      bgm1();
    });
  }

  void loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectedLang = (prefs.getString('languageSet') ?? "English");
      setLanguage();
    });
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:  Text("$lang1",
        style: TextStyle (fontSize: 30, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color:otherColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
                '$lang2',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 28
                ),
              ),
              SizedBox(height: screenHeight/20),
              Container(
              decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 4),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.orange[50],     
            ),

            child: IconButton(
              iconSize: 60,
              icon:Icon(audio ? Icons.volume_up_outlined : Icons.volume_mute_outlined),
              color: Colors.brown,
              onPressed: () {
                setState(() {
                  audio = !audio;
                });
                if(!audio){
                  FlameAudio.bgm.pause();
                  
                }else{
                  FlameAudio.bgm.resume();
                  
                }

              },
             
  ),),
            SizedBox(height: screenHeight/18),
             Text(
                '$lang3',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 28
                ),
              ),
              SizedBox(height: screenHeight/20),
              DecoratedBox(
                decoration: const BoxDecoration( 
                  color:Colors.white,
                ),
            child: DropdownButton(
              itemHeight: 60,
              value: selectCol,
              
              onChanged: (newValue){
                setState((){
                  selectCol = newValue.toString();
                  _color();
                });
              },
              items: colorlist.map((selectCol){
                return DropdownMenuItem(
                  child : Text(
                    selectCol,
                  ),
                value: selectCol,
                );
              }).toList(),
          ),),

          SizedBox(height: screenHeight/18),
             Text(
                '$lang4',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 28
                ),
              ),
              SizedBox(height: screenHeight/20),
              DecoratedBox(
                decoration: const BoxDecoration( 
                  color:Colors.white,
                ),
            child: DropdownButton(
              itemHeight: 60,
              value: selectedLang,
              
              onChanged: (newValue){
                setState((){
                  selectedLang = newValue.toString();
                  _language();
                });
              },
              items: langlist.map((selectedLang){
                return DropdownMenuItem(
                  child : Text(
                    selectedLang,
                  ),
                value: selectedLang,
                );
              }).toList(),
          ),)
          ]))
    );
  }
  Future <void> _color() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState((){
      prefs.setString('colorCode', selectCol);
      selectCol = (prefs.getString('colorCode') ?? "Default");
      bgm1();
      });
  }

  Future <void> _language() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState((){
      prefs.setString('languageSet', selectedLang);
      selectedLang = (prefs.getString('languageSet') ?? "English");
      setLanguage();
      });
  }
  
void bgm1() async{
  
  setState((){
    switch (selectCol) {
      case "Default":
        latestCol = color1.toString();
        break;

      case "Blue":
        latestCol = color2.toString();
        break;

      case "Red":
        latestCol = color3.toString();
        break;
    }
    valueString = latestCol.split('(0x')[1].split(')')[0]; // kind of hacky..
    value = int.parse(valueString, radix: 16);
    otherColor = Color(value);
    });
}

  void setLanguage() async{

    setState((){
    switch (selectedLang) {
      case "English":
        lang1 = "Back";
        lang2 = "Background Music";
        lang3 = "Background Color";
        lang4 = "Language";
        break;

      case "Malay":
        lang1 = "Kembali";
        lang2 = "Lagu Latar Belakang";
        lang3 = "Warna Latar Belakang";
        lang4 = "Bahasa";
        break;

    }
    });
  }
}