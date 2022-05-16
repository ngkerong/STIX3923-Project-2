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
  List<String> colorlist = [
     "Default",
     "Blue",
     "Red",
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
    });
  }

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectCol = (prefs.getString('colorCode') ?? "Default");
      bgm1();
    });
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Page",
        style: TextStyle (fontSize: 30, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color:otherColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Background Music',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 35
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
            const Text(
                'Background Color',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 35
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
}