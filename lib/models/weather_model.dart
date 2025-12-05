import 'package:intl/intl.dart';

class WeatherModel {
  final String city;
  final double temperature;
  final String weatherDescription;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.weatherDescription,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
  });

  // الحصول على وقت الشروق والغروب بتنسيق مقروء
  String get sunriseTime => _formatTime(sunrise);
  String get sunsetTime => _formatTime(sunset);

  // تحويل الوقت إلى تنسيق مناسب
  String _formatTime(int time) {
    try {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
      var format = DateFormat('HH:mm'); // تنسيق الوقت باستخدام 24 ساعة
      return format.format(dateTime);
    } catch (e) {
      return 'Data unavailable'; // في حالة حدوث خطأ في التحويل
    }
  }

  // تحويل البيانات من JSON إلى نموذج WeatherModel
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      weatherDescription: json['weather'][0]['description'],
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
