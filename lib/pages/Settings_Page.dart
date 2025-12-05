import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _unit = 'metric';      // metric = °C, imperial = °F
  bool _isDark = false;         // false = light, true = dark
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _unit = prefs.getString('unit') ?? 'metric';
      final themeString = prefs.getString('theme') ?? 'light';
      _isDark = themeString == 'dark';
      _isLoading = false;
    });
  }

  Future<void> _updateUnit(String newUnit) async {
    if (newUnit == _unit) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unit', newUnit);
    setState(() {
      _unit = newUnit;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newUnit == 'metric'
              ? 'Temperature unit set to Celsius (°C)'
              : 'Temperature unit set to Fahrenheit (°F)',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _updateTheme(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', dark ? 'dark' : 'light');
    setState(() {
      _isDark = dark;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Theme preference saved. It will apply next time you open the app.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.settings_suggest_outlined,
                            size: 60,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'App Settings',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Control how weather and theme are displayed in the app.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ======= Temperature unit section =======
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Temperature unit:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChoiceChip(
                                label: const Text('Celsius (°C)'),
                                selected: _unit == 'metric',
                                avatar: const Icon(Icons.thermostat),
                                onSelected: (selected) {
                                  if (selected) {
                                    _updateUnit('metric');
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              ChoiceChip(
                                label: const Text('Fahrenheit (°F)'),
                                selected: _unit == 'imperial',
                                avatar: const Icon(Icons.thermostat_outlined),
                                onSelected: (selected) {
                                  if (selected) {
                                    _updateUnit('imperial');
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 12),

                          // ======= Theme section =======
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Theme:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            title: const Text('Dark Mode'),
                            subtitle: Text(
                              _isDark
                                  ? 'Currently using dark theme'
                                  : 'Currently using light theme',
                            ),
                            value: _isDark,
                            onChanged: (value) {
                              _updateTheme(value);
                            },
                          ),

                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline, size: 18),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _unit == 'metric'
                                      ? 'Current temperature unit: Celsius (°C)'
                                      : 'Current temperature unit: Fahrenheit (°F)',
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
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
}
