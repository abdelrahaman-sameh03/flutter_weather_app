import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/weather_details_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> _favorites = [];
  final ApiService _apiService = ApiService();
  Map<String, WeatherModel?> _weatherDataMap = {};
  bool _isLoading = false;

  String _unit = 'metric'; // 'metric' = °C, 'imperial' = °F

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadUnit();
    await _loadFavorites();
  }

  Future<void> _loadUnit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _unit = prefs.getString('unit') ?? 'metric';
    });
  }

  double _convertTemp(double tempC) {
    if (_unit == 'imperial') {
      return tempC * 9 / 5 + 32;
    }
    return tempC;
  }

  String get _unitLabel => _unit == 'imperial' ? '°F' : '°C';

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('favorites') ?? [];

    setState(() {
      _favorites = stored;
      _isLoading = true;
    });

    for (final city in stored) {
      try {
        final weatherData = await _apiService.fetchWeather(city);
        if (!mounted) return;
        setState(() {
          _weatherDataMap[city] = weatherData;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _weatherDataMap[city] = null;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromFavorites(String city) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites.remove(city);
      _weatherDataMap.remove(city);
    });
    await prefs.setStringList('favorites', _favorites);
  }

  void _onCityTap(String city, WeatherModel? weatherData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(city),
        content: const Text(
          'What would you like to do with this favorite city?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _removeFromFavorites(city);
              Navigator.pop(context);
            },
            child: const Text(
              'Remove from favorites',
              style: TextStyle(color: Colors.red),
            ),
          ),
          if (weatherData != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherDetailsPage(
                      city: city,
                      weatherData: weatherData,
                      addToFavorites: (_) {},
                    ),
                  ),
                );
              },
              child: const Text('View weather'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF90CAF9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _favorites.isEmpty
                ? const Center(
                    child: Text(
                      'No favorite cities added yet',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final city = _favorites[index];
                      final weatherData = _weatherDataMap[city];

                      String subtitleText;
                      if (weatherData == null) {
                        subtitleText = 'Loading weather...';
                      } else {
                        final temp = _convertTemp(weatherData.temperature);
                        subtitleText =
                            'Temp: ${temp.toStringAsFixed(1)}$_unitLabel\n${weatherData.weatherDescription}';
                      }

                      return Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.location_city_outlined),
                          title: Text(
                            city,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(subtitleText),
                          isThreeLine: true,
                          trailing: const Icon(Icons.more_vert),
                          onTap: () => _onCityTap(city, weatherData),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
