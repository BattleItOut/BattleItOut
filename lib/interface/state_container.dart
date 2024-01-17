import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/utils/utilities.dart';
import 'package:flutter/material.dart';

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  const _InheritedStateContainer({required this.data, required super.child});

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
  final Widget child;

  const StateContainer({required this.child, super.key});

  static StateContainerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()!.data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  final Wrapper<Locale> _localeWrapper = Wrapper();
  List<Character> _savedCharacters = [];

  get savedCharacters => _savedCharacters;
  get locale => _localeWrapper.object;

  Future<void> loadCharacters() async {
    List<Character> characters = []; // await CharacterFactory().getAll();
    setState(() {
      _savedCharacters = characters;
    });
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
    loadCharacters();
    return _InheritedStateContainer(data: this, child: widget.child);
  }
}
