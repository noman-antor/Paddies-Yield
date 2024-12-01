import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:translator/translator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';
class weather_forecast
{

  double lat=0;
  double lon=0;
  final translator=GoogleTranslator();
  String key="f4580d26320009f256e9da74089fd513";
  String unit="metric";
  int year=0;
  int month=0;
  double max_temp=0;
  double min_temp=0;
  int humidity=0;
  double wind_speed=0;
  double dbl_humidity=0;

  WeatherFactory wf = new WeatherFactory("f4580d26320009f256e9da74089fd513");

  String convert_to_bn(String x) {
    String bengali = "";
    for (int i = 0; i < x.length; i++) {
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
          case '0':
            bengali = bengali + '০';
            break;
        }
    }
    return bengali;
  }

  Future<dynamic> get_place() async{

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      lon = position.longitude;
      List<Placemark>addr = await placemarkFromCoordinates(lat, lon);
      Placemark place = addr[0];
      return jsonEncode(
          {
            "street": place.street,
            "div": place.administrativeArea,
            "dist": place.locality
          }
      );

  }


  Future<dynamic> get_location_weather () async
    {

      Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat=position.latitude;
      lon=position.longitude;
      String url= "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$key&units=$unit";
      http.Response response=await http.get(Uri.parse(url));
      if(response.statusCode==200)
      {
          String data=response.body;
          dynamic val=jsonDecode(data);
          return val;

      }
      else {
          return 0;
      }
    }

    Future<dynamic> soil_prediction(double temp,double humd,double ph, int label)async
    {
      Dio dio=Dio();
      var response=await dio.post("http://192.168.0.104:8080/soil_test",
      data: jsonEncode(
        {
          "temp":temp,
          "humidity":humd,
          "ph":ph,
          "label":label
        }
      ));
      if(response.statusCode==200)
        {
          String x=response.data.toString();
          print(x);
          return jsonEncode({
            "N":convert_to_bn(x.substring(1,6)),
            "P":convert_to_bn(x.substring(8,13)),
            "K":convert_to_bn(x.substring(15,20))
          });

        }
      else
        {
          return 0;
        }

    }

  Future<dynamic> production_predict(int season, int dist, double area)async
  {
    Dio dio=Dio();
    var response=await dio.post("http://192.168.0.104:8080/product_predict",
        data: jsonEncode(
            {
              "season": season,
              "dist": dist,
              "area": area,
            }
        ));
    if(response.statusCode==200)
    {
      String x=response.data.toString();
      print(x);
      return jsonEncode({
        //[25698,                     5896321458963224          ]
        //[    25698     5896324]
        "production":convert_to_bn(x.split(",").first.split("[").last),
        "yield":convert_to_bn((x.split(",").last.split("]").first).substring(1,5)),

        "production_en":(x.split(",").first.split("[").last),
        "yield_en":((x.split(",").last.split("]").first).substring(1,5))
      });

    }
    else
    {
      return 0;
    }

  }

  Future<dynamic> fertil_predict(int season, int dist, double area, double prod, double yld)async
  {
    Dio dio=Dio();
    var response=await dio.post("http://192.168.0.104:8080/fertil_predict",
        data: jsonEncode(
            {
              "season": season,
              "dist": dist,
              "area": area,
              "prod":prod,
              "yld":yld
            }
        ));
    if(response.statusCode==200)
    {
      String x=response.data.toString();
      print(x);
      double fertil=double.parse(x.split(",").first.split("[").last);
      print(fertil);
      double pesti=double.parse((x.split(",").last.split("]").first).substring(1,10));
      print(pesti);
      return jsonEncode({
        "fertil":convert_to_bn((fertil/area).toString().substring(0,5)),
        "pes":convert_to_bn((pesti/area).toString().substring(0,5)),
      });

    }
    else
    {
      return 0;
    }

  }


}
