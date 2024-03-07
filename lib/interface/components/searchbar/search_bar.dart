import 'package:flutter/material.dart';

abstract class AbstractSearchList<T extends SearchListItemModel> extends StatefulWidget {
  final List<T> items;
  final Widget title;

  const AbstractSearchList({super.key, required this.title, required this.items});

  @override
  State<AbstractSearchList> createState();
}

abstract class AbstractSearchListState<K extends SearchListItemModel, T extends AbstractSearchList<K>>
    extends State<AbstractSearchList<K>> {
  List<K> items = [];
  List<K> filteredItems = [];

  Widget listEntryGenerator(List<K> filteredItems, int index);

  @override
  void initState() {
    super.initState();
    items = widget.items;
    items.sort((a, b) => a.name.compareTo(b.name));
    filteredItems = items;
  }

  void itemChange(bool val, int index) {}

  late final TextEditingController controller = TextEditingController()
    ..addListener(() {
      setState(() {
        filteredItems = items.where((e) {
          return e.name.toLowerCase().contains(controller.text.trim().toLowerCase());
        }).toList();
      });
    });

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(child: widget.title),
      TextField(
        textAlign: TextAlign.center,
        controller: controller,
        decoration: const InputDecoration(hintText: 'Enter text to search'),
      ),
      Expanded(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 10,
          children: List.generate(filteredItems.length, (index) {
            return Center(child: listEntryGenerator(filteredItems, index));
          }).toList(),
        ),
      )
    ]);
  }
}

abstract class SearchListItemModel {
  get name;
}
