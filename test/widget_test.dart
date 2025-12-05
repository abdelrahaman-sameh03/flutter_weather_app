import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/pages/favorites_page.dart';
import 'package:weather_app/pages/settings_page.dart';

void main() {
  testWidgets(
      'Test navigation between HomePage, FavoritesPage, and SettingsPage',
      (WidgetTester tester) async {
    // نشغّل التطبيق باستخدام ThemeMode ثابت (مثلاً light)
    await tester.pumpWidget(
      const WeatherApp(themeMode: ThemeMode.light),
    );

    // نتأكد إن HomePage ظهرت
    expect(find.byType(HomePage), findsOneWidget);

    // ================== المفضلات ==================

    // ندور على أيقونة المفضلة في الـ AppBar
    final favoritesIcon = find.byIcon(Icons.favorite);
    expect(favoritesIcon, findsOneWidget);

    // نضغط على أيقونة المفضلة
    await tester.tap(favoritesIcon);
    await tester.pumpAndSettle();

    // نتأكد إننا وصلنا لصفحة FavoritesPage
    expect(find.byType(FavoritesPage), findsOneWidget);

    // نرجع للصفحة اللي قبلها (HomePage)
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);

    // ================== الإعدادات ==================

    // ندور على أيقونة الإعدادات في الـ AppBar
    final settingsIcon = find.byIcon(Icons.settings);
    expect(settingsIcon, findsOneWidget);

    // نضغط على أيقونة الإعدادات
    await tester.tap(settingsIcon);
    await tester.pumpAndSettle();

    // نتأكد إن SettingsPage ظهرت
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
