import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/widgets.dart';

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  const _InheritedStateContainer({Key? key, required this.data, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final List<Character> savedCharacters;

  const StateContainer({
    required this.child,
    required this.savedCharacters,
    Key? key
  }) : super(key: key);

  static StateContainerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()!.data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  List<Character> getCharacters() {
    return widget.savedCharacters;
  }
  void addCharacter(Character character) {
    setState(() {
      widget.savedCharacters.add(character);
    });
  }
  void removeCharacterAt(int index) {
    setState(() {
      widget.savedCharacters.removeAt(index);
    });
  }
  void removeCharacterLast() {
    setState(() {
      widget.savedCharacters.removeLast();
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