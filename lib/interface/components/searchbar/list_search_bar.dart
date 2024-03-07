import 'package:battle_it_out/interface/components/searchbar/search_bar.dart';
import 'package:flutter/material.dart';

class SearchList extends AbstractSearchList<SearchListItem> {
  const SearchList({super.key, required super.title, required super.items});

  @override
  State<AbstractSearchList> createState() => _SearchListState();
}

class _SearchListState extends AbstractSearchListState<SearchListItem, SearchList> {
  @override
  Widget listEntryGenerator(List<SearchListItem> filteredItems, int index) {
    return ListTile(
        dense: true,
        title: Text(
          filteredItems[index].name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        leading: SizedBox(
          child: filteredItems[index].img != null
              ? Image.asset(filteredItems[index].img!, fit: BoxFit.cover)
              : const SizedBox(),
        ));
  }
}

class SearchListItem extends SearchListItemModel {
  @override
  String name;
  dynamic value;
  String? img;

  SearchListItem({
    required this.name,
    this.value,
    this.img,
  });
}
