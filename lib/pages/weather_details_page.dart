import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherDetailsPage extends StatefulWidget {
  final String city;
  final WeatherModel weatherData;
  final Function(String) addToFavorites;

  const WeatherDetailsPage({
    super.key,
    required this.city,
    required this.weatherData,
    required this.addToFavorites,
  });

  @override
  State<WeatherDetailsPage> createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  String _unit = 'metric';

  @override
  void initState() {
    super.initState();
    _loadUnit();
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

  @override
  Widget build(BuildContext context) {
    final weather = widget.weatherData;
    final temp = _convertTemp(weather.temperature);
    final feels = _convertTemp(weather.feelsLike);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.city} Weather'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Add to favorites',
            onPressed: () {
              widget.addToFavorites(widget.city);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.city} added to favorites'),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF64B5F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud,
                      size: 70,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      weather.city,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weather.weatherDescription,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${temp.toStringAsFixed(1)}$_unitLabel',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Feels like: ${feels.toStringAsFixed(1)}$_unitLabel',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoTile(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: '${weather.humidity}%',
                        ),
                        _infoTile(
                          icon: Icons.air,
                          label: 'Wind',
                          value: '${weather.windSpeed} m/s',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoTile(
                          icon: Icons.wb_sunny_outlined,
                          label: 'Sunrise',
                          value: weather.sunriseTime,
                        ),
                        _infoTile(
                          icon: Icons.nightlight_round,
                          label: 'Sunset',
                          value: weather.sunsetTime,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
