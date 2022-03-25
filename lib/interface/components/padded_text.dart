import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:flutter/material.dart';

class PaddedText extends Text {
  final String text;

  final BuildContext? context;
  final EdgeInsets? padding;
  final bool hidden;

  const PaddedText(this.text,
      {this.context, Key? key, TextAlign? textAlign, TextStyle? style, this.hidden = false, this.padding})
      : super(hidden ? "" : text, key: key, textAlign: textAlign, style: style);

  TableColumnWidth get columnWidth => const FlexColumnWidth();

  from(PaddedText other, {TextStyle? style}) {
    return PaddedText(other.text,
        context: other.context!,
        key: other.key,
        textAlign: other.textAlign,
        style: other.style ?? style,
        hidden: other.hidden,
        padding: other.padding);
  }

  Widget create() {
    if (padding != null) {
      return Padding(padding: padding!, child: this);
    } else {
      return this;
    }
  }
}

class LocalisedText extends PaddedText {
  LocalisedText(String text, BuildContext context,
      {Key? key, textAlign = TextAlign.left, TextStyle? style, EdgeInsets? padding, bool hidden = false})
      : super(AppLocalizations.of(context).localise(text),
            context: context, key: key, textAlign: textAlign, style: style, padding: padding, hidden: hidden);

  @override
  from(PaddedText other, {TextStyle? style}) {
    return PaddedText(other.text,
        context: other.context!,
        key: other.key,
        textAlign: other.textAlign,
        style: other.style ?? style,
        hidden: other.hidden,
        padding: other.padding);
  }
}

class LocalisedShortcut extends PaddedText {
  final CharacteristicType type = CharacteristicType.shortcut;

  @override
  TableColumnWidth get columnWidth => const FixedColumnWidth(48);

  LocalisedShortcut(String data, BuildContext context,
      {Key? key, textAlign = TextAlign.center, TextStyle? style, EdgeInsets? padding, bool hidden = false})
      : super(AppLocalizations.of(context).localise(data),
            context: context, key: key, textAlign: textAlign, style: style, hidden: hidden);

  @override
  from(PaddedText other, {TextStyle? style}) {
    return PaddedText(other.data!,
        context: other.context,
        key: other.key,
        textAlign: other.textAlign,
        style: other.style ?? style,
        hidden: other.hidden,
        padding: other.padding);
  }
}

class IntegerText extends PaddedText {
  @override
  TableColumnWidth get columnWidth => const FixedColumnWidth(32);

  IntegerText(int? value,
      {Key? key, textAlign = TextAlign.center, TextStyle? style, EdgeInsets? padding, bool hidden = false})
      : super(value != null ? value.toString() : "", key: key, textAlign: textAlign, style: style, hidden: hidden);

  @override
  from(PaddedText other, {TextStyle? style}) {
    return PaddedText(other.text,
        context: other.context,
        key: other.key,
        textAlign: other.textAlign,
        style: other.style ?? style,
        hidden: other.hidden,
        padding: other.padding);
  }
}
