import 'package:flutter/material.dart';

class CheckboxListWithSearchBar<T> extends StatefulWidget {
  final List<T> items;
  final Widget title;
  final String Function(T item) convert;

  const CheckboxListWithSearchBar({super.key, required this.title, required this.items, required this.convert});

  @override
  State<CheckboxListWithSearchBar<T>> createState() => _CheckboxListWithSearchBarState<T>();
}

class _CheckboxListWithSearchBarState<T> extends State<CheckboxListWithSearchBar<T>> {
  List<CheckBoxListTileModel> checkBoxItemList = [];
  List<CheckBoxListTileModel> filteredCheckBoxItemList = [];

  @override
  void initState() {
    super.initState();
    checkBoxItemList = widget.items.map((e) => CheckBoxListTileModel(title: widget.convert(e))).toList();
    checkBoxItemList.sort((a, b) => a.title.compareTo(b.title));
    filteredCheckBoxItemList = checkBoxItemList;
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxItemList[index].isCheck = val;
    });
  }

  late final TextEditingController controller = TextEditingController()
    ..addListener(() {
      setState(() {
        filteredCheckBoxItemList = checkBoxItemList
            .where((e) => e.title.toLowerCase().contains(controller.text.trim().toLowerCase()))
            .toList();
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
          children: List.generate(filteredCheckBoxItemList.length, (index) {
            return CheckboxListTile(
                dense: true,
                title: Text(
                  filteredCheckBoxItemList[index].title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
                value: filteredCheckBoxItemList[index].isCheck,
                secondary: SizedBox(
                  child: filteredCheckBoxItemList[index].img != null
                      ? Image.asset(filteredCheckBoxItemList[index].img!, fit: BoxFit.cover)
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

class CheckBoxListTileModel {
  String title;
  bool isCheck;
  String? img;

  CheckBoxListTileModel({
    required this.title,
    this.isCheck = false,
    this.img = 'assets/icon.png',
  });
}
