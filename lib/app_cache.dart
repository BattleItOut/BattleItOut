import 'package:battle_it_out/persistence/character.dart';

class AppCache {
  late final List<Character>? _characters;
  static late final AppCache _instance;

  factory AppCache() {
    return _instance;
  }

  AppCache._init();

  AppCache.init({required List<Character> characters}) {
    _instance = AppCache._init();
    _instance._characters = characters;
  }

  List<Character> get characters => _characters!;
}
