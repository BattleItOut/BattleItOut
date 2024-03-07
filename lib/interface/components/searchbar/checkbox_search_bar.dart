import 'package:battle_it_out/interface/components/searchbar/search_bar.dart';
import 'package:flutter/material.dart';

class SearchBarCheckboxList extends AbstractSearchList<CheckboxSearchListItem> {
  const SearchBarCheckboxList({super.key, required super.title, required super.items});

  @override
  State<AbstractSearchList> createState() => _SearchBarCheckboxListState();
}

class _SearchBarCheckboxListState extends AbstractSearchListState<CheckboxSearchListItem, SearchBarCheckboxList> {
  @override
  Widget listEntryGenerator(List<CheckboxSearchListItem> filteredItems, int index) {
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
          setState(() {
            items[index].checked = val!;
          });
        });
  }
}

class CheckboxSearchListItem extends SearchListItemModel {
  @override
  String name;
  dynamic value;
  bool checked;
  String? img;

  CheckboxSearchListItem({
    required this.name,
    this.value,
    this.checked = false,
    this.img,
  });
}
