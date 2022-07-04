import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:flutter/services.dart';
import 'package:card_matching/model/config.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddImagePage extends StatefulWidget {

  const AddImagePage({Key? key}) : super(key: key);

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  double screenHeight = 0.0, screenWidth = 0.0;
  File? _image;
  var pathAsset = "assets/images/add-image.png";
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceID = " ";
  String selectedLang = " ";
  String lang1 = " ";
  String lang2 = " ";
  String lang3 = " ";
  String lang4 = " ";
  String lang5 = " ";
  String lang6 = " ";
  String lang7 = " ";
  String lang8 = " ";
  String lang9 = " ";
  String lang10 = " ";
  String lang11 = " ";
  String lang12 = " ";
  String lang13 = " ";
  String lang14 = " ";
  String lang15 = " ";
  String lang16 = " ";
  String selectCol = " ";
  String latestCol = " ";
   Color color4 = Color(0xFFFDD54F);
  Color color5 = Color(0xFF8C9EFF);
  Color color6 = Color(0xFFF48FB1);
  String valueString =" ";
  int value = 0;
  Color otherColor2 = Color(0x00000000);
  
  @override
  void initState() {
    super.initState();
    getDeviceID();
    loadColor();
    loadLanguage();
  }

   void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectCol = (prefs.getString('colorCode') ?? "Default");
      bgm2();
    });
  }

  void loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      selectedLang = (prefs.getString('languageSet') ?? "English");
      setLanguage();
    });
  }

  void bgm2() async{
  
    switch (selectCol) {
      case "Default":
        latestCol = color4.toString();
        break;

      case "Blue":
        latestCol = color5.toString();
        break;

      case "Red":
        latestCol = color6.toString();
        break;
    }
    valueString = latestCol.split('(0x')[1].split(')')[0]; // kind of hacky..
    value = int.parse(valueString, radix: 16);
    otherColor2 = Color(value);
}

void setLanguage() async{

    setState((){
    switch (selectedLang) {
      case "English":
        lang1 = "Back";
        lang2 = "Add Image";
        lang3 = "Select from";
        lang4 = "Gallery";
        lang5 = "Camera";
        lang6 = "Crop";
        lang7 = "Crop Image";
        lang8 = "Please upload image";
        lang9 = "Add this image";
        lang10 = "Are you sure?";
        lang11 = "Yes";
        lang12 = "No";
        lang13 = "Adding new image..";
        lang14 = "Processing...";
        lang15 = "Success";
        lang16 = "Failed";
        break;

      case "Malay":
        lang1 = "Kembali";
        lang2 = "Tambah Gambar";
        lang3 = "Pilih dari";
        lang4 = "Galeri";
        lang5 = "Kamera";
        lang6 = "Potong";
        lang7 = "Potong Gambar";
        lang8 = "Sila muat naik gambar";
        lang9 = "Tambah gambar ini";
        lang10 = "Adakah anda pasti?";
        lang11 = "Ya";
        lang12 = "Tidak";
        lang13 = "Tambahkan Gambar Baru..";
        lang14 = "Memproses...";
        lang15= "Berjaya";
        lang16 = "Gagal";
        break;

    }
    });
  }

  void getDeviceID()async {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    setState((){
      deviceID = androidInfo.androidId;
    });
   
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("$lang1", style: TextStyle (fontSize: 20, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Flexible(
              flex: 5,
              child: GestureDetector(
                onTap: _uploadImage,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Card(
                    child: Container(
                        decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage(pathAsset)
                            : FileImage(_image!) as ImageProvider,
                        fit: BoxFit.scaleDown,
                      ),
                    )),
                  ),
                ),
              )),
         
                            const SizedBox(
                          height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: otherColor2,
                    fixedSize: Size(screenWidth, screenHeight / 13)),
                child: Text('$lang2', style: TextStyle (fontSize: 18,  fontWeight: FontWeight.bold)),
                onPressed: () => {_newImageDialog(),}
                          
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ));       
  }
  
 void _uploadImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(
              "$lang3",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: otherColor2,
                      fixedSize: Size(screenWidth / 5, screenHeight / 10)),
                  child:Text('$lang4' , style: TextStyle (fontSize: 12)),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromGallery(),

                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: otherColor2,
                      fixedSize: Size(screenWidth / 5, screenHeight / 10)),
                  child: Text('$lang5',style: TextStyle (fontSize: 12)),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                ),
              ],
            ));
      },
    );
  }
  
  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,

              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings:  AndroidUiSettings(
            toolbarTitle: '$lang6',
            toolbarColor: Colors.deepOrange,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings:  IOSUiSettings(
          title: '$lang7',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }
  void _newImageDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "$lang8",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "$lang9",
            style: TextStyle(),
          ),
          content: Text("$lang10", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: Text(
                "$lang11",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addNewImage();
               
              },
            ),
            TextButton(
              child: Text(
                "$lang12",
                style: TextStyle(),
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
    void _addNewImage() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _userid = deviceID;
    
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("$lang13"),
        title: Text("$lang14"));
    progressDialog.show();

    String base64Image = base64Encode(_image!.readAsBytesSync());
    
    http.post(Uri.parse(Config.server + "/card_matching/php/addcard.php"), 
    body: {
      "userid": _userid,
      "image": base64Image,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "$lang15",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        Navigator.of(context).pop();
        return;
      }else{
         Fluttertoast.showToast(
            msg: "$lang16",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
    progressDialog.dismiss();
  }
}