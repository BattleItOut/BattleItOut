import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ListItem extends Container {
  ListItem({
    Key? key,
    required String name,
    EdgeInsets? margin,
    double? height,
    BoxDecoration? decoration
  }) : super(
    key: key,
    margin: const EdgeInsets.all(4.0),
    height: height,
    decoration: decoration,
    child: Center(child: Text(name))
  );
}

class CharacterListItem extends ListItem {
  CharacterListItem({Key? key, required String name, required int colorCode}) : super(
      key: key,
      name: name,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.red[colorCode],
      ),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  List<CharacterListItem> characters = <CharacterListItem>[
    CharacterListItem(name: 'Player A', colorCode: 600),
    CharacterListItem(name: 'Player B', colorCode: 500),
    CharacterListItem(name: 'Player D', colorCode: 400),
  ];

  void _append() {
    setState(() {
      characters.add(CharacterListItem(
        name: 'Player Hm',
        colorCode: 300,
      ));
    });
  }

  void _pop(int index) {
    setState(() {
      characters.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ListItem> entries = <ListItem>[];
    for (int i = 0; i < characters.length; i++) {
      if (i == 0) {
        entries.add(ListItem(name: 'Current'));
      } if (i == 1) {
        entries.add(ListItem(name: 'Next'));
      }
      entries.add(characters[i]);
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                child: entries[index],
                onTap: () {
                  if (entries[index] is CharacterListItem) {
                    int actualIndex = index;
                    if (index > 1) {
                      actualIndex--;
                    } if (index > 0) {
                      actualIndex--;
                    }
                    _pop(actualIndex);
                  }
                }
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _append,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
