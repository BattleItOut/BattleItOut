import 'package:battle_it_out/interface/screens/main_screen.dart';
import 'package:battle_it_out/interface/state_container.dart';
import 'package:battle_it_out/interface/themes.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/providers/ancestry_provider.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/providers/database_provider.dart';
import 'package:battle_it_out/providers/race_provider.dart';
import 'package:battle_it_out/providers/size_provider.dart';
import 'package:battle_it_out/providers/skill_base_provider.dart';
import 'package:battle_it_out/providers/skill_group_provider.dart';
import 'package:battle_it_out/providers/skill_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogs();
  setupGetIt();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<SizeProvider>(create: (_) => GetIt.instance.get<SizeProvider>()),
    ChangeNotifierProvider<RaceProvider>(create: (_) => GetIt.instance.get<RaceProvider>()),
    ChangeNotifierProvider<AttributeProvider>(create: (_) => GetIt.instance.get<AttributeProvider>()),
    ChangeNotifierProvider<AncestryProvider>(create: (_) => GetIt.instance.get<AncestryProvider>()),
    ChangeNotifierProvider<SkillProvider>(create: (_) => GetIt.instance.get<SkillProvider>()),
    ChangeNotifierProvider<BaseSkillProvider>(create: (_) => GetIt.instance.get<BaseSkillProvider>()),
    ChangeNotifierProvider<SkillGroupProvider>(create: (_) => GetIt.instance.get<SkillGroupProvider>()),
  ], child: const StateContainer(child: MyApp())));
}

void setupGetIt() {
  GetIt.instance.registerSingleton<DatabaseProvider>(DatabaseProvider());
  GetIt.instance.registerSingleton<SizeProvider>(SizeProvider());
  GetIt.instance.registerSingleton<RaceProvider>(RaceProvider());
  GetIt.instance.registerSingleton<AttributeProvider>(AttributeProvider());
  GetIt.instance.registerSingleton<AncestryProvider>(AncestryProvider());
  GetIt.instance.registerSingleton<SkillProvider>(SkillProvider());
  GetIt.instance.registerSingleton<BaseSkillProvider>(BaseSkillProvider());
  GetIt.instance.registerSingleton<SkillGroupProvider>(SkillGroupProvider());
}

void setupLogs() {
  Logger.root.level = Level.FINE;
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
