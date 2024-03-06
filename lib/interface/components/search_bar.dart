import 'package:flutter/material.dart';

class CheckboxListWithSearchBar extends StatefulWidget {
  final List<CheckBoxListTile> items;
  final Widget title;

  const CheckboxListWithSearchBar({super.key, required this.title, required this.items});

  @override
  State<CheckboxListWithSearchBar> createState() => _CheckboxListWithSearchBarState();
}

class _CheckboxListWithSearchBarState<T> extends State<CheckboxListWithSearchBar> {
  List<CheckBoxListTile> items = [];
  List<CheckBoxListTile> filteredItems = [];

  @override
  void initState() {
    super.initState();
    items = widget.items;
    items.sort((a, b) => a.name.compareTo(b.name));
    filteredItems = items;
  }

  void itemChange(bool val, int index) {
    setState(() {
      items[index].checked = val;
    });
  }

  late final TextEditingController controller = TextEditingController()
    ..addListener(() {
      setState(() {
        filteredItems =
            items.where((e) => e.name.toLowerCase().contains(controller.text.trim().toLowerCase())).toList();
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
            return CheckboxListTile(
                dense: true,
                title: Text(
                  filteredItems[index].name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
                value: filteredItems[index].checked,
                secondary: SizedBox(
                  child: filteredItems[index].img != null
                      ? Image.asset(filteredItems[index].img!, fit: BoxFit.cover)
                      : const SizedBox(),
                ),
                onChanged: (bool? val) {
                  itemChange(val!, index);
                });
          }).toList(),
        ),
      )
    ]);
  }
}

class CheckBoxListTile {
  String name;
  dynamic value;
  bool checked;
  String? img;

  CheckBoxListTile({
    required this.name,
    this.value,
    this.checked = false,
    this.img,
  });
}
