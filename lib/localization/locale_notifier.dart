import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = const Locale('en');
  static const String _localeKey = 'selectedLocale';

  LocaleNotifier() {
    _loadLocale(); // Load saved locale on initialization
  }

  Locale get locale => _locale;

  void setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
      notifyListeners();
    }
  }
}

// Usage in your app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context);

    return MaterialApp(
      locale: localeNotifier.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'), // Add more locales as needed
      ],
      localizationsDelegates: const [
        // Add your localization delegates here
      ],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locale Provider Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Locale: ${localeNotifier.locale.languageCode}'),
            ElevatedButton(
              onPressed: () {
                localeNotifier.setLocale(const Locale('es'));
              },
              child: const Text('Change to Spanish'),
            ),
          ],
        ),
      ),
    );
  }
}
