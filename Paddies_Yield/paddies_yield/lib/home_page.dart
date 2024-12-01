import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:paddies_yield/converter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:translator/translator.dart';
import 'package:weather/weather.dart';

import 'weather.dart';

class home_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _home_page();
  }
}

class _home_page extends State<home_page> {

  String bn_day = "";
  String bn_month = "";
  String bn_year = "";
  String bar = "";

  int cloud = 0;
  String bn_cloud = "";

  int day = DateTime.now().day;
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int l = DateTime.now().weekday;
  int check_loading = 0;

  //For getting weatherb information
  weather_forecast wf = weather_forecast();
  double temp = 0;
  double humd = 0;
  String bn_temp = "";

  String weather_desc = "";
  String weather_desc_bang = "";

  //for getting local place information
  String street = "";
  String sublocal = "";
  String div = "";
  String dist = "";

  GoogleTranslator translator = GoogleTranslator();

  var items = ["ধান", "ভুট্টা", "ছোলা", "শিম", "মুগ ডাল", "মসুর ডাল",
    "ডালিম", "কলা", "আম", "আঙ্গুর", "তরমুজ", "আপেল", "কমলা",
    "পেঁপে", "নারকেল", "তুলা", "পাট"];
  String dropdown_value = "ধান";
  int crop_index = 0;
  double ph_value = 0.0;

  final TextEditingController take_ph = TextEditingController();
  final TextEditingController take_jomir_poriman = TextEditingController();
  double jomir_poriman=0;

  String nitrogen="";
  String phosphoras="";
  String potasium="";


  int create_dist_statistics=0;
  int get_production=0;
  int get_fertil=0;

  List<String> dist_stat=["ঢাকা", "ফরিদপুর", "গাজীপুর", "গোপালগঞ্জ", "জামালপুর", "কিশোরগঞ্জ", "মাদারীপুর", "মানিকগঞ্জ",
    "মুন্সীগঞ্জ", "ময়মনসিংহ", "নারায়ণগঞ্জ", "নরসিংদী", "নেত্রকোনা", "রাজবাড়ী", "শরীয়তপুর", "শেরপুর", "টাঙ্গাইল",
    "বগুড়া", "জয়পুরহাট", "নওগাঁ", "নাটোর", "নবাবগঞ্জ", "পাবনা", "রাজশাহী", "সিরাজগঞ্জ", "দিনাজপুর", "গাইবান্ধা",
    "কুড়িগ্রাম", "লালমনিরহাট", "নীলফামারী", "পঞ্চগড়", "রংপুর", "ঠাকুরগাঁও", "বরগুনা", "বরিশাল", "ভোলা", "ঝালকাঠি",
    "পটুয়াখালী", "পিরোজপুর", "বান্দরবান", "ব্রাহ্মণবাড়িয়া", "চাঁদপুর", "চট্টগ্রাম", "কুমিল্লা", "কক্সবাজার", "ফেনী", "খাগড়াছড়ি",
    "লক্ষ্মীপুর", "নোয়াখালী", "রাঙামাটি", "হবিগঞ্জ", "মৌলভীবাজার", "সুনামগঞ্জ", "সিলেট", "বাগেরহাট", "চুয়াডাঙ্গা", "যশোর",
    "ঝিনাইদহ", "খুলনা", "কুষ্টিয়া", "মাগুরা", "মেহেরপুর", "নড়াইল", "সাতক্ষীরা"];
  int dist_code=0;
  String dist_value="রংপুর";

  List<String> seasn_stat=["শরৎ","গ্রীষ্ম","বর্ষা","শীত","বারো মাসি"];
  int seasn_code=0;
  String seasn_value="বারো মাসি";

  String production_from_api="";
  double production_from_api_dbl=0;
  String yield_from_api="";
  double yield_from_api_dbl=0;
  String fertilizer_from_api="";
  String pesticide_from_api="";


  void convert_date_to_bangla() {
    setState(() {
      bn_day = convert_to_bn(day);
      bn_month = convert_to_bn(month);
      bn_year = convert_to_bn(year);
      bar = weekday(l);
    });
  }


  double convert_to_en(String x) {
    String english = "";
    for (int i = 0; i < x.length; i++)
      {
        setState(() {
          switch (x.toString()[i]) {
            case '১':
              english = english + '1';
              break;
            case '২':
              english = english + '2';
              break;
            case '৩':
              english = english + '3';
              break;
            case '৪':
              english = english + '4';
              break;
            case '৫':
              english = english + '5';//4.+5=4.5
              break;
            case '৬':
              english = english + '6';
              break;
            case '৭':
              english = english + '7';
              break;
            case '৮':
              english = english + '8';
              break;
            case '৯':
              english = english + '9';
              break;
            case '.':
              english = english + '.'; //4+.=4.
              break;
            case '০':
              english= english+ '0';
              break;
          }
        });
      }
    if(english=="")
      {
        return double.parse(x);
      }
    else
      {
        return double.parse(english);
      }


  }

  void load_weather_data() async {

    dynamic weather = await wf.get_location_weather();
    setState(() {
      temp = weather["main"]["temp"];
      bn_temp = convert_to_bn_double(temp);

      humd=(weather["main"]["humidity"]).toDouble();

      weather_desc = weather["weather"][0]["description"];

      cloud=weather["clouds"]["all"];
      bn_cloud=convert_to_bn(cloud);

      translator.translate(weather_desc, from: "en", to: "bn").then((value) {
        setState(() {
          weather_desc_bang = value.toString();
        });

      });
    });

    dynamic place = await wf.get_place();
    place = jsonDecode(place);
    setState(() {
      converter conv = converter();
      street = place["street"];
      div = conv.div_converter(place["div"].split(" ").first);
      dist = conv.dist_converter(place["dist"].toString());
      check_loading=1;
    });
  }

  String convert_to_bn(int x) {
    String bengali = "";
    for (int i = 0; i < x.toString().length; i++) {
      setState(() {
        switch (x.toString()[i]) {
          case '1':
            bengali = bengali + '১';
            break;
          case '2':
            bengali = bengali + '২';
            break;
          case '3':
            bengali = bengali + '৩';
            break;
          case '4':
            bengali = bengali + '৪';
            break;
          case '5':
            bengali = bengali + '৫';
            break;
          case '6':
            bengali = bengali + '৬';
            break;
          case '7':
            bengali = bengali + '৭';
            break;
          case '8':
            bengali = bengali + '৮';
            break;
          case '9':
            bengali = bengali + '৯';
            break;
          default:
            bengali = bengali + '০';
        }
      });
    }
    return bengali;
  }

  String convert_to_bn_double(double x) {
    String bengali = "";
    for (int i = 0; i < x.toString().length; i++) {
      setState(() {
        switch (x.toString()[i]) {
          case '1':
            bengali = bengali + '১';
            break;
          case '2':
            bengali = bengali + '২';
            break;
          case '3':
            bengali = bengali + '৩';
            break;
          case '4':
            bengali = bengali + '৪';
            break;
          case '5':
            bengali = bengali + '৫';
            break;
          case '6':
            bengali = bengali + '৬';
            break;
          case '7':
            bengali = bengali + '৭';
            break;
          case '8':
            bengali = bengali + '৮';
            break;
          case '9':
            bengali = bengali + '৯';
            break;
          case '.':
            bengali = bengali + '.';
            break;
          default:
            bengali = bengali + '০';
        }
      });
    }
    return bengali;
  }

  String weekday(int x) {
    List<String> a = [
      "সোমবার",
      "মঙ্গলবার",
      "বুধবার",
      "বৃহস্পতিবার",
      "শুক্রবার",
      "শনিবার",
      "রবিবার",
    ];
    for (int i = 1; i <= 7; i++) {
      if (x == i) {
        return a[i - 1];
      }
    }
    return "";
  }

  Widget anim()
  {
    return Container(height: 200,width: 400,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/home1.png"),fit: BoxFit.cover),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), spreadRadius: 5,blurRadius: 10,offset: Offset(0,3))]
      ),
    ).animate().fadeIn(duration: 600.milliseconds).swap(duration: 3000.milliseconds,builder: (_,__)=>


        Container(height: 200,width: 400,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/home2.png"),fit: BoxFit.cover),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5),spreadRadius: 5,blurRadius: 10,offset: Offset(0,3))]
          ),
        ).animate().fadeIn(duration: 600.milliseconds).swap(duration: 3000.milliseconds,builder: (_,__)=>


            Container(height: 200,width: 400,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/home3.png"),fit: BoxFit.cover),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5),spreadRadius: 5,blurRadius: 10,offset: Offset(0,3))]
              ),
            ).animate().fadeIn(duration: 600.milliseconds).swap(duration:3000.milliseconds,builder: (_,__)=>
                        anim())));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    convert_date_to_bangla();
    load_weather_data();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            //container for building location widget
            Row(
              children: AnimationConfiguration.toStaggeredList(
                duration: Duration(milliseconds: 800),
                  childAnimationBuilder: (widget)=> SlideAnimation(
                    verticalOffset: -(MediaQuery.of(context).size.height / 2),
                      child: FadeInAnimation(child: widget,)),
                  children:[
                    Container(
                      height: 180,
                      width: 369,
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(30))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                          (check_loading == 1)?Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 800),
                                childAnimationBuilder: (widget) => SlideAnimation(
                                  //verticalOffset: MediaQuery.of(context).size.height / 2,
                                  horizontalOffset:
                                  -(MediaQuery.of(context).size.height / 2),
                                  child: FadeInAnimation(child: widget),
                                ),
                                children: [
                                  SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.home,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("$street,",
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.white)),
                                    ],
                                  ),
                                  Text("$div বিভাগ, $dist ।",
                                      style: TextStyle(fontSize: 18, color: Colors.white)),
                                  SizedBox(height: 15),
                                  Text(
                                    "আজ $bn_day/$bn_month/$bn_year ইং,",
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                  Text("রোজ $bar ।",
                                      style: TextStyle(fontSize: 18, color: Colors.white))
                                ]),
                          ):Text("অপেক্ষমান.....",style: TextStyle(color: Colors.white,fontSize: 35),),


                          SizedBox(width: 50),
                          if (check_loading == 1)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: AnimationConfiguration.toStaggeredList(
                                  duration: const Duration(milliseconds: 800),
                                  childAnimationBuilder: (widget) => SlideAnimation(
                                    horizontalOffset:
                                    (MediaQuery.of(context).size.height / 2),
                                    child: FadeInAnimation(child: widget),
                                  ),
                                  children: [
                                    SizedBox(height: 70),
                                    Text("$bn_temp °C",
                                        style: TextStyle(fontSize: 18, color: Colors.white)),
                                    SizedBox(height: 5),
                                    Text(
                                      "মেঘের পরিমানঃ $bn_cloud%",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                    SizedBox(height: 0),
                                    IconButton(onPressed: (){
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>home_page()));
                                    },
                                        icon: Icon(Icons.refresh,color: Colors.white,size: 25,) )
                                  ]
                              ),
                            )
                        ],
                      ),
                    ),
                  ]
              ),
            ),



            //Container for visibling multiple pictures as decoration
            SizedBox(height: 20),
            anim(),


            //Building rasaoinik bishleshon
            SizedBox(
              height: 50,
            ),
            Text("জমির রাসায়নিক বিশ্লেষণ",
                style: TextStyle(color: Colors.purple,fontSize: 20,
                    fontWeight: FontWeight.bold,decoration: TextDecoration.underline)),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("আবাদকৃত ফসলঃ",
                    style: TextStyle(fontSize: 18,)),
                SizedBox(width: 10),
                Container(
                  width: 90,
                  height: 28,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: DropdownButton(
                      value: dropdown_value,
                      underline: const SizedBox(),
                      items: items.map((String items){
                        return DropdownMenuItem(
                            child: Text(items),
                            value: items);
                      }).toList(),
                      onChanged: (String? newvalue){
                        setState(() {
                          dropdown_value=newvalue!;
                          for(int i=0;i<items.length;i++)
                          {
                            if(dropdown_value==items[i])
                            {
                              crop_index=i;
                              print(crop_index);
                            }
                          }
                        });
                      }
                    ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("pH এর মান?",
                    style: TextStyle(fontSize: 18,)),
                SizedBox(width: 10),
                Container(
                  height: 27,
                  width: 70,
                  child:TextField(
                    keyboardType: TextInputType.number,
                    controller: take_ph,
                    onSubmitted: (value){
                      setState(() {
                        ph_value=double.parse(take_ph.text);
                      });
                    },
                    decoration: InputDecoration(filled: true,fillColor: Colors.white,
                        enabledBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)))
                    ),
                    cursorColor: Colors.purple,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: ()async{
             dynamic result= await wf.soil_prediction(temp, humd, ph_value, crop_index);
             result=jsonDecode(result);
             setState(() {
               nitrogen=result["N"].toString();
               phosphoras=result["P"].toString();
               potasium=result["K"].toString();
               print(nitrogen);
               print(phosphoras);
               print(potasium);
               show_soil_materail(context);
             });
            },
                child: Text("বিশ্লেষণ করুন",style: TextStyle(fontSize: 16)),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.purple))),
            SizedBox(height: 70),
            InkWell(
              onTap: (){
                setState(() {
                  create_dist_statistics=1;
                });
              },
              child: Text("জেলাভিত্তিক শস্য উৎপাদন পরিসংখ্যান দেখুন",
              style: TextStyle(color: Colors.purple,fontSize: 20,decoration: TextDecoration.underline),),
            ),


            //Dropdown buttons implementation
            SizedBox(height: 30),
            if(create_dist_statistics==1)
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //For building district dropdown
                SizedBox(width: 10),
                Text("জেলা? ",style: TextStyle(fontSize: 18)),
                Container(
                  height: 30,
                  width: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.purple)),
                  child: DropdownButton(
                    underline: const SizedBox(),
                    value: dist_value,
                    items: dist_stat.map((String item){
                      return DropdownMenuItem(child: Text(item),value: item);
                    }).toList(),
                    onChanged: (String? newvalue){
                      setState(() {
                        dist_value=newvalue!;
                        print(dist_stat.length);
                        for(int i=0;i<dist_stat.length;i++)
                          {
                            if(dist_value==dist_stat[i])
                              {
                                dist_code=i;
                              }}
                      });
                    },
                  ),
                ),


                //For building season dropdown
                SizedBox(width: 25),
                Text("মৌসুম? ",style: TextStyle(fontSize: 18)),
                Container(
                  height: 30,
                  width: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.purple)),
                  child: DropdownButton(
                    underline: const SizedBox(),
                    value: seasn_value,
                    items: seasn_stat.map((String item){
                      return DropdownMenuItem(child: Text(item),value: item);
                    }).toList(),
                    onChanged: (String? newvalue){
                      setState(() {
                        seasn_value=newvalue!;
                        print(seasn_stat.length);
                        for(int i=0;i<seasn_stat.length;i++)
                        {
                          if(seasn_value==seasn_stat[i])
                          {
                            seasn_code=i;
                          }
                        }
                      });
                    },
                  ),
                ),
                SizedBox(width: 10)],
            ),


            //building jomir poriman
              SizedBox(height: 30),
            if(create_dist_statistics==1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("জমির পরিমান?",style:TextStyle(fontSize: 18)),
                  SizedBox(width: 10),
                  Container(
                    height: 30,
                    width: 200,
                    child: TextField(
                      controller: take_jomir_poriman,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.purple,
                      decoration: InputDecoration(filled: true,fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                          focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                          label: Text("হেক্টর",style: TextStyle(color: Colors.purple)),
                          suffixIcon: IconButton(icon: Icon(Icons.clear,size: 15,color: Colors.purple),
                              onPressed:(){
                                take_jomir_poriman.clear();
                              }
                          )
                      ),
                    ),
                  )

                ],
              ),


            //Api call button
            if(create_dist_statistics==1)
              SizedBox(height: 30),
            if(create_dist_statistics==1)
              ElevatedButton(onPressed: ()async{
                jomir_poriman=convert_to_en(take_jomir_poriman.text);
                print(jomir_poriman);
                dynamic result=await wf.production_predict(seasn_code, dist_code, jomir_poriman);
                result=jsonDecode(result);
                setState(() {
                  production_from_api=result["production"];
                  production_from_api_dbl=double.parse(result["production_en"]);

                  yield_from_api=result["yield"];
                  yield_from_api_dbl=double.parse(result["yield_en"]);

                  get_production=1;

                });
              },
                child: Text("পরিসংখ্যান",style: TextStyle(fontSize: 16)),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.purple))
              ),


            //Printing Result to the display
            SizedBox(height: 20),
            if(create_dist_statistics==1 && get_production==1)
              Text("সর্বাধিক ফলনঃ $production_from_api টন",style: TextStyle(fontSize: 18)),
            if(create_dist_statistics==1 && get_production==1)
              Text("প্রতি হেক্টর ফলনঃ $yield_from_api টন/হেক্টর",style: TextStyle(fontSize: 18)),


            //This is the widget where the api call again for getting the value of fertilizer & pesticides
            //based on the value of production & yield that we get before
              SizedBox(height: 30,),
            if(create_dist_statistics==1 && get_production==1)
              InkWell(
                child: Text("উৎপাদিত ফলনের সম্ভাব্য কীটনাশক ও সার",
                    style: TextStyle(fontSize: 18,color: Colors.purple,decoration: TextDecoration.underline)),

                onTap: ()async{
                  dynamic result=await wf.fertil_predict(seasn_code, dist_code, jomir_poriman, production_from_api_dbl, yield_from_api_dbl);
                  result=jsonDecode(result);
                  setState(() {
                    fertilizer_from_api=result["fertil"];
                    pesticide_from_api=result["pes"];
                    get_fertil=1;
                  });
                },
              ),


            //Displaying the result of fertilizer &
            if(create_dist_statistics==1 && get_production==1 && get_fertil==1)
              Text("প্রতি হেক্টর সারঃ $fertilizer_from_api কেজি",style:TextStyle(fontSize: 18)),
            if(create_dist_statistics==1 && get_production==1 && get_fertil==1)
              Text("প্রতি হেক্টর কীটনাশকঃ $pesticide_from_api কেজি",style:TextStyle(fontSize: 18)),

              SizedBox(height: 45)
            ],
          ),
        )
      ),
    );
  }
  show_soil_materail(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        content: Container(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("রাসায়নিক উপাদানের পরিমান",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline)),
              SizedBox(height: 15),
              Text("নাইট্রোজেনঃ $nitrogen ভাগ",style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text("ফসফরাসঃ $phosphoras ভাগ",style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text("পটাশিয়ামঃ $potasium ভাগ",style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }
    );
  }
}
