import 'package:http/http.dart' as http;
import 'dart:convert';

class AirIndex {

  String? location;
  String? aqi;
  String? url;

  AirIndex({required this.location, this.url, this.aqi});

  Future<String?> getAirIndex(String? location) async {
    try {
      Uri precessedString = Uri.parse('https://api.waqi.info/feed/$location/?token=b3f27a39ed7d8df0af98fee43d2aec2c507ddb38');
      http.Response response = await http.get(precessedString);
      var data = json.decode(response.body);
      aqi = data['data']['aqi'].toString();

      return aqi;
    }
    catch(e) {
      return e.toString();
    }
  }
}