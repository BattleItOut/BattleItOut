import 'package:battle_it_out/interface/screens/main_screen.dart';
import 'package:battle_it_out/interface/state_container.dart';
import 'package:battle_it_out/interface/themes.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/providers/ancestry_provider.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/providers/race_provider.dart';
import 'package:battle_it_out/providers/size_provider.dart';
import 'package:battle_it_out/providers/skill/base_skill_provider.dart';
import 'package:battle_it_out/providers/skill/skill_group_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:battle_it_out/utils/utilities.dart';
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
    ChangeNotifierProvider<SizeRepository>(create: (_) => GetIt.instance.get<SizeRepository>()),
    ChangeNotifierProvider<RaceRepository>(create: (_) => GetIt.instance.get<RaceRepository>()),
    ChangeNotifierProvider<AttributeRepository>(create: (_) => GetIt.instance.get<AttributeRepository>()),
    ChangeNotifierProvider<AncestryRepository>(create: (_) => GetIt.instance.get<AncestryRepository>()),
    ChangeNotifierProvider<SkillRepository>(create: (_) => GetIt.instance.get<SkillRepository>()),
    ChangeNotifierProvider<BaseSkillRepository>(create: (_) => GetIt.instance.get<BaseSkillRepository>()),
    ChangeNotifierProvider<SkillGroupRepository>(create: (_) => GetIt.instance.get<SkillGroupRepository>()),
  ], child: const StateContainer(child: MyApp())));
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
