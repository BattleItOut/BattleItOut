import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:flutter/cupertino.dart';

abstract class PaddedText extends Text {
  final EdgeInsets? padding;

  const PaddedText(String data, {Key? key, TextAlign? textAlign, TextStyle? style, this.padding}) :
        super(data, key: key, textAlign: textAlign, style: style);

  TableColumnWidth get columnWidth => const FlexColumnWidth();

  create() {
    if (padding != null) {
      return Padding(
          padding: padding!,
          child: this
      );
    } else {
      return this;
    }
  }}

class LocalisedText extends PaddedText {
  LocalisedText(String data, BuildContext context, {Key? key, textAlign = TextAlign.left, TextStyle? style, EdgeInsets? padding}) :
        super(AppLocalizations.of(context).localise(data), key: key, textAlign: textAlign, style: style, padding: padding);
}

class LocalisedShortcut extends PaddedText {
  final CharacteristicType type = CharacteristicType.shortcut;

  @override
  TableColumnWidth get columnWidth => const FixedColumnWidth(48);

  LocalisedShortcut(String data, BuildContext context, {Key? key, textAlign = TextAlign.center}) :
        super(AppLocalizations.of(context).localise(data), key: key, textAlign: textAlign);
}

class IntegerText extends PaddedText {
  @override
  TableColumnWidth get columnWidth => const FixedColumnWidth(32);

  IntegerText(int? data, {Key? key, textAlign = TextAlign.center}) :
        super(data != null ? data.toString() : "", key: key, textAlign: textAlign);
}