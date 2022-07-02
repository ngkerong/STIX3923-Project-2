import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:card_matching/model/config.dart';
import 'package:card_matching/model/card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'addimagepage.dart';
import 'deleteimagepage.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key}) : super(key: key);

  @override
  UploadImagePageState createState() => UploadImagePageState();

}

class UploadImagePageState extends State<UploadImagePage>{

  late List _cardList = [];
  late double screenHeight, screenWidth;
  late ScrollController _scrollController;
  int scrollcount = 10;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceID = " ";
  String selectedLang = " ";
  String lang1 = " ";
  String lang2 = " ";
  String lang3 = " ";
  String lang4 = " ";
  String lang5 = " ";
  String latestCol = " ";
  String selectCol = " ";
  Color color1 = Color(0xFFFFECB3);
  Color color2 = Color(0xFFE1F5FE);
  Color color3=  Color(0xFFFFCDD2); 
  String valueString =" ";
  int value = 0;
  Color otherColor = Color(0x00000000);


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadCards();
    loadLanguage();
    loadColor();
  }

  void loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectedLang = (prefs.getString('languageSet') ?? "English");
      setLanguage();
    });
  }

  void setLanguage() async{

    setState((){
    switch (selectedLang) {
      case "English":
        lang1 = "Back";
        lang2 = "Please Upload an Image here.";
        lang3 = "Upload image and play them in Level Custom";
        lang4 = "Message";
        lang5 = "The limited amount of image is 8. Please delete some of the images.";
        break;

      case "Malay":
        lang1 = "Kembali";
        lang2 = "Muat Naik Gambar di sini.";
        lang3 = "Muat naik gambar dan mainkan di Level Custom";
        lang4 = "Mesej";
        lang5 = "Jumlah gambar yang terhad ialah 8. Sila padamkan beberapa gambar.";
        break;

    }
    });
  }

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("$lang1",
        style: TextStyle (fontSize: 30, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
        actions: <Widget>[
    IconButton(
      icon: const Icon(
        Icons.restart_alt,
        color: Colors.white,
        size: 40.0
      ),
      onPressed: () {
        _loadCards();
      },
    ),
    IconButton(
      icon: const Icon(
        Icons.add,
        color: Colors.white,
        size: 40.0
      ),
      onPressed: () {
        if(_cardList.length <= 7) {
          Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => const AddImagePage()));
        }else{
          imageDialog();
        }
      },
    ),
    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 40.0
      ),
      onPressed: () {
         Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => const DeleteImagePage()));
      },
    ),
  ],
      ),
      body: _cardList.isEmpty
        ? Center(
                child: Text("$lang2",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
          : RefreshIndicator(
        onRefresh: _loadCards ,
        child:  Column(children: [
          SizedBox(height:screenHeight/20),
          Text(
                '$lang3',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 15
                ),
              ),
            SizedBox(height:screenHeight/20),
         _cardList == null ?  const Flexible(
          child: Center(child: Text("No Data")),):

             Flexible(
               child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      controller:_scrollController,
                      childAspectRatio: ((screenWidth / screenHeight * 1.5)),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                    children: List.generate(scrollcount, (index){
              return InkWell(
                child: Container(
                child: Column(
                  children:[
                      const SizedBox(height:10),
                      CachedNetworkImage(
                            height: 120,
                            width: 120,
                            imageUrl: Config.server + "/card_matching/images/" + _cardList[index]["cardid"] + ".png",
                ),const SizedBox(height:10),
                      Text( _cardList[index]["date"] + "\n",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                ]),
                decoration: BoxDecoration(
                    color: otherColor,
                    borderRadius: BorderRadius.circular(15)),
                ),
              );
            }),
             ),

               )))]
        ),
      ),
      );  
  }
  Future<void> _loadCards() async {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    String userid = androidInfo.androidId;

    http.post(Uri.parse(Config.server + "/card_matching/php/loadcard.php"), 
    body: {
      "userid":userid,
    
    }).then((response) {
      var rescode = response.statusCode;
    if(rescode == 200){
      setState(() {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      _cardList = parsedJson['data']['cards'];
      lang2 = "Contain Data";
      if (scrollcount >= _cardList.length) {
            scrollcount = _cardList.length;
          }
      }
      );
        print(_cardList);
      } else {
        lang2 = "No data";
        return;
      } 
  });
  }
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (_cardList.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= _cardList.length) {
            scrollcount = _cardList.length;
          }
        }
      });
    }
   }

  void imageDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "$lang4",
            style: TextStyle(fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold),
          ),
          content: Text("$lang5", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Ok",
                style: TextStyle(fontSize: 15, color: Colors.brown, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
 
  }