import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'http://api.weatherapi.com/v1';
  static const String _apiKey = 'e21afd65435d489abfa220316251107';

  static Future<WeatherData?> getCurrentWeather(String city) async {
    try {
      final url = Uri.parse('$_baseUrl/current.json?key=$_apiKey&q=$city&aqi=no');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Weather API Response: $data'); // Debug print
        return WeatherData.fromJson(data);
      } else {
        print('Weather API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching weather: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  static Future<ForecastData?> getForecast(String city, int days) async {
    try {
      final url = Uri.parse('$_baseUrl/forecast.json?key=$_apiKey&q=$city&days=$days&aqi=no&alerts=no');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ForecastData.fromJson(data);
      } else {
        print('Weather Forecast API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching forecast: $e');
      return null;
    }
  }
}

class WeatherData {
  final String locationName;
  final String country;
  final double tempC;
  final double tempF;
  final String condition;
  final String conditionIcon;
  final int humidity;
  final double windKph;
  final double windMph;
  final String windDir;
  final double pressureMb;
  final double feelsLikeC;
  final double feelsLikeF;
  final int uvIndex;
  final double visKm;
  final DateTime localTime;

  WeatherData({
    required this.locationName,
    required this.country,
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.conditionIcon,
    required this.humidity,
    required this.windKph,
    required this.windMph,
    required this.windDir,
    required this.pressureMb,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.uvIndex,
    required this.visKm,
    required this.localTime,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    try {
      final location = json['location'];
      final current = json['current'];
      
      return WeatherData(
        locationName: location['name']?.toString() ?? '',
        country: location['country']?.toString() ?? '',
        tempC: _parseDouble(current['temp_c']),
        tempF: _parseDouble(current['temp_f']),
        condition: current['condition']['text']?.toString() ?? '',
        conditionIcon: 'https:${current['condition']['icon']}',
        humidity: _parseInt(current['humidity']),
        windKph: _parseDouble(current['wind_kph']),
        windMph: _parseDouble(current['wind_mph']),
        windDir: current['wind_dir']?.toString() ?? '',
        pressureMb: _parseDouble(current['pressure_mb']),
        feelsLikeC: _parseDouble(current['feelslike_c']),
        feelsLikeF: _parseDouble(current['feelslike_f']),
        uvIndex: _parseInt(current['uv']),
        visKm: _parseDouble(current['vis_km']),
        localTime: DateTime.parse(location['localtime'] ?? DateTime.now().toIso8601String()),
      );
    } catch (e) {
      print('Error parsing WeatherData: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ForecastData {
  final WeatherData current;
  final List<ForecastDay> forecastDays;

  ForecastData({
    required this.current,
    required this.forecastDays,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    final current = WeatherData.fromJson(json);
    final forecastList = json['forecast']['forecastday'] as List;
    
    final forecastDays = forecastList.map((day) => ForecastDay.fromJson(day)).toList();
    
    return ForecastData(
      current: current,
      forecastDays: forecastDays,
    );
  }
}

class ForecastDay {
  final DateTime date;
  final double maxTempC;
  final double minTempC;
  final double maxTempF;
  final double minTempF;
  final String condition;
  final String conditionIcon;
  final double chanceOfRain;
  final double totalPrecipMm;
  final double maxWindKph;
  final double avgHumidity;
  final int uvIndex;

  ForecastDay({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.maxTempF,
    required this.minTempF,
    required this.condition,
    required this.conditionIcon,
    required this.chanceOfRain,
    required this.totalPrecipMm,
    required this.maxWindKph,
    required this.avgHumidity,
    required this.uvIndex,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    final day = json['day'];
    
    return ForecastDay(
      date: DateTime.parse(json['date']),
      maxTempC: (day['maxtemp_c'] ?? 0).toDouble(),
      minTempC: (day['mintemp_c'] ?? 0).toDouble(),
      maxTempF: (day['maxtemp_f'] ?? 0).toDouble(),
      minTempF: (day['mintemp_f'] ?? 0).toDouble(),
      condition: day['condition']['text'] ?? '',
      conditionIcon: 'https:${day['condition']['icon']}',
      chanceOfRain: (day['daily_chance_of_rain'] ?? 0).toDouble(),
      totalPrecipMm: (day['totalprecip_mm'] ?? 0).toDouble(),
      maxWindKph: (day['maxwind_kph'] ?? 0).toDouble(),
      avgHumidity: (day['avghumidity'] ?? 0).toDouble(),
      uvIndex: (day['uv'] ?? 0).toInt(),
    );
  }
}
