# 🌤️ Flutter Weather App

A multi-page Flutter application that retrieves real-time weather data using the **OpenWeatherMap Current Weather API**.  
The app allows users to search for cities, view detailed weather information, save favorite locations, and switch temperature units between °C and °F.

---

## 🚀 Features

### 🔍 Search Screen
- Search weather by city
- Fetch real-time API data
- Navigate to detailed weather screen

### 🌦️ Weather Details Screen
- City name
- Temperature (°C or °F)
- Weather description
- Feels like temperature
- Humidity %
- Wind speed
- Sunrise & Sunset times
- Add city to favorites

### ⭐ Favorites Screen
- View all saved favorite cities
- Tap to see detailed weather info
- Persistent storage using **SharedPreferences**

### ⚙️ Settings Screen
- Switch between **Celsius (°C)** and **Fahrenheit (°F)**  
- Temperature changes apply instantly using **Provider State Management**

---

## 📂 Folder Structure

```
lib/
  config/
    api_config.dart            # Contains REAL API key (ignored from GitHub)
    api_config_example.dart    # Placeholder example uploaded to GitHub
  models/
    weather_model.dart
    settings_model.dart
  services/
    api_service.dart
  pages/
    home_page.dart
    weather_details_page.dart
    favorites_page.dart
    settings_page.dart
  main.dart
```

This structure follows the required Flutter architecture guidelines.

---

## 🔑 API Key Setup

Because API keys should **not** be uploaded online, follow these steps:

### 1️⃣ Copy the example file:
```
lib/config/api_config_example.dart → lib/config/api_config.dart
```

### 2️⃣ Add your API key inside:
```dart
const String openWeatherApiKey = 'YOUR_REAL_API_KEY_HERE';
```

⚠️ IMPORTANT:  
`api_config.dart` is **ignored** by GitHub using `.gitignore`, so your real key stays private.

---

## 🛠 How to Run the Application

### Install dependencies:
```bash
flutter pub get
```

### Run the app:
```bash
flutter run
```

### Build APK (required for submission):
```bash
flutter build apk --release
```

APK will be found at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧰 Technologies Used

- Flutter 3.x  
- Dart  
- Provider (State Management)  
- SharedPreferences  
- HTTP REST API  
- OpenWeatherMap API  

---

## 📝 Notes

- The REAL API key is NOT included in the GitHub repository.
- Use the provided example config file to set up your own key.
