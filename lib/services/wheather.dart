import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Wheather{
  String? location;
  DateTime? currentTime;
  String? sunrise;
  String? sunset;
  String? temp;
  //String? feelsLike;
  double? pressure;
  int? humidity;
  int? cloudiness;
  double? uvi;
  double? windSpeed;
  String? windDirection;
  double? rain;
  double? snow;
  String? main;
  String? desc;
  String? icon;
  String? moonPhase;
  int? isDay;
  List days = [];

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  Wheather({this.location});

  getWheather() async {
    String apiKey = 'e5b70f1bd26f405888692100231101';
    Future<http.Response> currentRes = http.get(Uri.parse('http://api.weatherapi.com/v1/current.json?key=e5b70f1bd26f405888692100231101&q=$location&aqi=no'));
    Map data = {};
    Map locationData = {};
    Map current ={};
    Map condition = {};
    await currentRes.then((value) => {
      data = jsonDecode(value.body),
      current = data['current'],
      locationData = data['location'],
      condition = current['condition'],
      icon = condition['icon'],
      rain = current['precip_in'],
      temp = (current['temp_c']).toString(),
      desc = condition['text'].toString(),
      windSpeed = current['wind_kph'],
      windDirection = current['wind_dir'].toString(),
      humidity = current['humidity'],
      cloudiness = current['cloud'],
      uvi = current['uv'],
      isDay = current['is_day'],
      currentTime = dateFormat.parse(locationData['localtime'].toString()),      
    });
  }

  getAstronomy() async {
    String apiKey = 'e5b70f1bd26f405888692100231101';
    
    Future<http.Response> astronomyRes = http.get(Uri.parse('http://api.weatherapi.com/v1/astronomy.json?key=e5b70f1bd26f405888692100231101&q=$location&aqi=no'));
    Map data = {};
    Map astronomy = {};
    Map astro = {};
    await astronomyRes.then((val) => {
      data = jsonDecode(val.body),
      astronomy = data['astronomy'],
      astro = astronomy['astro'],
      sunrise = astro['sunrise'],
      sunset = astro['sunset'],
      moonPhase = astro['moon_phase'],
      
    });
  }

  getForecast() async {
    String apiKey = 'e5b70f1bd26f405888692100231101';
    Future<http.Response> forecastRes = http.get(Uri.parse('http://api.weatherapi.com/v1/forecast.json?key=e5b70f1bd26f405888692100231101&q=$location&days=5&aqi=no&alerts=no'));
    Map data = {};
    Map forecast = {};
    List forecastDay = [];
    List daysRaw = [];
    Map conditions = {};
    Map dayOne = {};
    String avgTemp;
    String dayDate;
    String condition;
    await forecastRes.then((value) => {
      data = jsonDecode(value.body),
      forecast = data['forecast'],
      forecastDay = forecast['forecastday'],
      forecastDay.forEach((day) => {
        dayDate = day['date'].toString(),
        dayOne = day['day'],
        conditions = dayOne['condition'],
        condition = conditions['text'].toString(),
        avgTemp = dayOne['avgtemp_c'].toString(),
        days.add({'date': dayDate, 'avgtemp': avgTemp, 'condition': condition}),
      }),      
      print(days[0]),
    });
  }
}