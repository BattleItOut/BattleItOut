import 'package:battle_it_out/interface/components/padded_text.dart';

class TableLine {
  List<PaddedText> children;

  TableLine({required this.children});

  create() {
    return [for (var value in children) value.create()];
  }
}