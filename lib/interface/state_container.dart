import 'dart:convert';

import 'package:battle_it_out/persistence/dao/character_dao.dart';
import 'package:battle_it_out/persistence/entities/character.dart';
import 'package:battle_it_out/utils/utilities.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  const _InheritedStateContainer({Key? key, required this.data, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
  final Widget child;

  const StateContainer({required this.child, Key? key}) : super(key: key);

  static StateContainerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()!.data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  final Wrapper<Locale> _localeWrapper = Wrapper();
  final List<Character> _savedCharacters = [];

  get savedCharacters => _savedCharacters;
  get locale => _localeWrapper.object;

  @override
  initState() {
    loadCharacters().then((value) => debugPrint("Characters loaded"));
    super.initState();
  }

  Future<void> loadCharacters() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final templates = json.decode(manifestJson).keys.where((String key) => key.startsWith('assets/templates'));

    for (var template in templates) {
      var json = jsonDecode(await rootBundle.loadString(template));
      Character character = await CharacterFactory().fromMap(json);
      setState(() {
        _savedCharacters.add(character);
      });
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _localeWrapper.object = locale;
    });
  }

  void addCharacter(Character character) {
    setState(() {
      _savedCharacters.add(character);
    });
  }

  void removeCharacterAt(int index) {
    setState(() {
      _savedCharacters.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
