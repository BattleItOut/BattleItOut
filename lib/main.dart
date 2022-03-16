import 'dart:convert';

import 'package:battle_it_out/interface/themes.dart';
import 'package:battle_it_out/interface/screens/turn_order_screen.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/state_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(StateContainer(child: const MyApp(), savedCharacters: await loadTemplates()));
}

Future<List<Character>> loadTemplates() async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final templates = json.decode(manifestJson).keys.where((String key) => key.startsWith('assets/templates'));

  List<Character> templateCharacters = [];
  for (var template in templates) {
    var json = jsonDecode(await rootBundle.loadString(template));
    Character character = await Character.create(json);
    templateCharacters.add(character);
  }
  return templateCharacters;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState state = context.findAncestorStateOfType<MyAppState>()!;
    state.changeLanguage(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale? _locale;

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BattleItOut',
      themeMode: ThemeMode.system,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: AppLocalizationsDelegate.supportedLocales,
      home: const TurnOrderScreen(),
    );
  }
}