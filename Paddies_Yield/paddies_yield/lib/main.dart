import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:paddies_yield/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'TiroBangla-Regular'
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var colorizeColors=[
    Colors.purple,
    Colors.white,
  ];

  void get_permission() async
  {
    if(!await Permission.location.isGranted)
    {
      await Permission.location.request();
    }
    if(!await Permission.storage.status.isGranted)
    {
      await Permission.storage.request();
    }
    if(!await Permission.camera.isGranted)
    {
      await Permission.camera.request();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_permission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
          height: double.infinity,
         width: double.infinity,
         color: Colors.white,
         child: Center(
           child: AnimatedTextKit(
             totalRepeatCount: 1,
             onFinished: (){
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>home_page()));
             },
             animatedTexts: [
               ColorizeAnimatedText("PADDIES YIELD",
                   textStyle: TextStyle(fontFamily: "Times New Roman",fontSize: 35,fontWeight: FontWeight.bold),
                   colors: colorizeColors,
                   speed: Duration(milliseconds: 300)
              )
             ],
           ),
         ),
       ),
    );
  }
}
