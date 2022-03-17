import 'package:battle_it_out/interface/themes.dart';
import 'package:battle_it_out/interface/screens/turn_order_screen.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/interface/state_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const StateContainer(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const TurnOrderScreen(),
    );
  }
}
