import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/fishing_trip.dart';
import 'services/fishing_trip_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  // Initialise Hive
  await Hive.initFlutter();
  Hive.registerAdapter(FishingTripAdapter());

  // Initialise le service
  final service = FishingTripService();
  await service.init();

  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  final FishingTripService service;

  const MyApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: service,
      child: MaterialApp(
        title: 'Gestion Peche Artisanale',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
          Locale('en', 'US'),
        ],
        locale: const Locale('fr', 'FR'),
        home: const MainScreen(),
      ),
    );
  }
}