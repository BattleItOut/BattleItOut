import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:flutter/cupertino.dart';

class TableEntity {
  TableLine? header;
  List<TableLine> children;
  bool headerHidden;

  TableEntity({this.header, this.headerHidden = false, required this.children});

  List<TableRow> create() {
    List<TableRow> result = [];
    if (header != null && !headerHidden) {
      result.add(header!.create());
    }
    for (TableLine row in children) {
      result.add(row.create());
    }
    return result;
  }
}

class TableLine {
  List<PaddedText> children;
  TextStyle? defaultStyle;

  TableLine({required this.children, TextStyle? style, this.defaultStyle});

  TableRow create() {
    List<PaddedText> updatedChildren = [for (var value in children) value.from(value, style: defaultStyle)];
    return TableRow(children: [for (var value in updatedChildren) value.create()]);
  }
}