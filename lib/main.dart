import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'pages/favorites_page.dart';
import 'pages/settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final themeString = prefs.getString('theme') ?? 'light';
  final ThemeMode themeMode =
      themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;

  runApp(WeatherApp(themeMode: themeMode));
}

class WeatherApp extends StatelessWidget {
  final ThemeMode themeMode;

  const WeatherApp({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      themeMode: themeMode,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: HomePage(),
      routes: {
        '/favorites': (context) => FavoritesPage(),
        '/settings': (context) =>  SettingsPage(),
      },
    );
  }
}
