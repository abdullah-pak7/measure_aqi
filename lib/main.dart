import 'package:flutter/material.dart';
import 'package:measure_aqi/aqi_mmt.dart';
// import 'package:measure_aqi/home_aqi.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
  home: MeasureAirQualityIndex(),
));

class MeasureAirQualityIndex extends StatefulWidget {

  @override
  State<MeasureAirQualityIndex> createState() => _MeasureAirQualityIndexState();
}

class _MeasureAirQualityIndexState extends State<MeasureAirQualityIndex> {

  HomeIndex homeCity = HomeIndex();
  Position? current_position;
  List<AirIndex> locations = [
    AirIndex(location: 'Karachi', url: 'karachi', aqi: ''),
    AirIndex(location: 'Lahore', url: 'lahore', aqi: ''),
    AirIndex(location: 'Islamabad', url: 'islamabad', aqi: ''),
    AirIndex(location: 'Peshawar', url: 'peshawar', aqi: ''),
  ];

  var index;

  @override
  void initState() {
    loadData();
    UpdateCurrentCity();
    // setState(() {});
    super.initState();
  }

  void loadData() async {
    Future.forEach(locations, (element) async {
      element.aqi = await element.getAirIndex(element.location);
    });
    // setState(() {});
  }

  Future assignPosition() async {
     LocationPermission permission = await Geolocator.requestPermission();
     LocationPermission permission1 = await Geolocator.checkPermission();
     current_position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future UpdateCurrentCity() async {

    // loadData();
    await assignPosition();
    HomeIndex instance= HomeIndex();
    Map thisCity = Map();
    String longitude = current_position!.longitude.toString();
    String latitude = current_position!.latitude.toString();

    thisCity = await instance.getCurrentAirIndex(latitude, longitude) as Map;

    homeCity.location = thisCity['data']['city']['name'].toString();
    homeCity.aqi = thisCity['data']['aqi'].toString();
    homeCity.time = thisCity['data']['time']['s'].toString();
    homeCity.dompol = thisCity['data']['dominentpol'].toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('Measure AQI',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
            letterSpacing: 1.0,
          ),),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          const SizedBox(height: 50.0),
          Text('Home Town : ${homeCity.location}',
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),),
          Text('Air Quality Index : ${homeCity.aqi}',
            style: TextStyle(
              fontSize: 16.0,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),),
          Text('Measurment Time : ${homeCity.time}',
            style: TextStyle(
              fontSize: 16.0,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),),
          Text('Dominent Pollutent : ${homeCity.dompol}',
            style: TextStyle(
              fontSize: 16.0,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),),
          const SizedBox(height: 50.0),
          Row(
            children: [
              Container(
                height: 450.0,
                width: 400.0,
                child: ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 1.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('City : ${locations[index].location}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                ),),
                              SizedBox(width: 5.0),
                              Text('AQI : ${locations[index].aqi}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: Colors.grey[700],
                                ),),
                            ],
                          ),
                        ),
                      );
                    }
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class HomeIndex {

  String? location;
  String? longitude;
  String? latitude;
  String? aqi;
  String? time;
  String? dompol;

  HomeIndex();

  Future getCurrentAirIndex(String latitude, String longitude) async {
    try {
      Uri precessedString = Uri.parse('https://api.waqi.info/feed/geo:$latitude;$longitude/?token=b3f27a39ed7d8df0af98fee43d2aec2c507ddb38');
      http.Response response = await http.get(precessedString);
      var data = json.decode(response.body);
      return data;
    }
    catch(e) {
      return(e).toString();
    }
  }
}