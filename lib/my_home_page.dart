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
  List<ListItem> entries = <ListItem>[
    ListItem(name: 'Current'),
    CharacterListItem(name: 'Player A', colorCode: 600),
    ListItem(name: 'Next'),
    CharacterListItem(name: 'Player B', colorCode: 500),
    CharacterListItem(name: 'Player C', colorCode: 400),
  ];

  void _append() {
    setState(() {
      entries.add(CharacterListItem(
        name: 'Player Hm',
        colorCode: 300,
      ));
    });
  }

  void _pop(int index) {
    setState(() {
      entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                    _pop(index);
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
