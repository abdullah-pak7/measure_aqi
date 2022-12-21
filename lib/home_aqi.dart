import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

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

      print(data);

      HomeIndex? city;
      city?.location = data['data']['city']['name'].toString();
      city?.aqi = data['data']['aqi'].toString();
      city?.dompol = data['data']['dominentpol'].toString();
      city?.time = data['data']['time']['s'].toString();

      return city as HomeIndex;
    }
    catch(e) {
      return(e).toString();
    }
  }
}