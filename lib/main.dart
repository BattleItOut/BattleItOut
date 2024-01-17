import 'package:battle_it_out/interface/screens/main_screen.dart';
import 'package:battle_it_out/interface/state_container.dart';
import 'package:battle_it_out/interface/themes.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/utils/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';

void main() async {
  logs();
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.connect();
  runApp(const StateContainer(child: MyApp()));
}

void logs() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BattleItOut',
      themeMode: ThemeMode.system,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      locale: StateContainer.of(context).locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: AppLocalizationsDelegate.supportedLocales,
      home: const MainScreen(),
    );
  }
}
