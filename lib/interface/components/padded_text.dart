import 'package:battle_it_out/localisation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaddedText extends StatefulWidget {
  final String text;
  final BuildContext? context;
  final bool hidden;
  final EdgeInsets? padding;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool editMode;
  final int? maxLines;
  final List<TextInputFormatter> formatters;
  final Function(String)? onChange;
  final TextInputType? keyboardType;

  static const InputDecoration decorationStandard = InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 5), isDense: true);
  static const InputDecoration decorationEdit = InputDecoration();

  const PaddedText(this.text,
      {Key? key,
      this.context,
      this.textAlign = TextAlign.left,
      this.style,
      this.hidden = false,
      this.padding,
      this.editMode = false,
      this.keyboardType,
      this.maxLines,
      this.formatters = const [],
      this.onChange})
      : super(key: key);

  TableColumnWidth get columnWidth => const FlexColumnWidth();

  static from(PaddedText other, {TextStyle? style, bool? editMode}) {
    return PaddedText(other.text,
        key: other.key,
        context: other.context,
        textAlign: other.textAlign,
        style: other.style?.merge(style) ?? style,
        hidden: other.hidden,
        padding: other.padding,
        editMode: editMode ?? other.editMode,
        keyboardType : other.keyboardType,
        maxLines: other.maxLines,
        formatters: other.formatters,
        onChange: other.onChange);
  }

  @override
  _PaddedTextState createState() => _PaddedTextState();
}

class _PaddedTextState extends State<PaddedText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: TextFormField(
          key: widget.editMode ? widget.key : UniqueKey(),
          initialValue: widget.text,
          textAlign: widget.textAlign,
          style: widget.style,
          maxLines: widget.maxLines,
          enabled: widget.editMode,
          decoration: widget.editMode ? PaddedText.decorationEdit : PaddedText.decorationStandard,
          inputFormatters: widget.formatters,
          keyboardType: widget.keyboardType,
          onChanged: (text)=>{
            widget.onChange != null ? widget.onChange!(text) : {}
          }
        ));
  }
}

class LocalisedText extends PaddedText {
  LocalisedText(String text, BuildContext context,
      {Key? key,
      textAlign = TextAlign.left,
      TextStyle? style,
      EdgeInsets? padding,
      bool hidden = false,
      bool editMode = false,
      Function(String)? onChange})
      : super(AppLocalizations.of(context).localise(text),
            context: context,
            key: key,
            textAlign: textAlign,
            style: style,
            padding: padding,
            hidden: hidden,
            editMode: editMode,
            onChange: onChange);
}

class LocalisedShortcut extends PaddedText {
  @override
  TableColumnWidth get columnWidth => const FixedColumnWidth(48);

  LocalisedShortcut(String data, BuildContext context,
      {Key? key,
      textAlign = TextAlign.center,
      TextStyle? style,
      EdgeInsets? padding,
      bool hidden = false,
      Function(String)? onChange})
      : super(AppLocalizations.of(context).localise(data),
            context: context, key: key, textAlign: textAlign, style: style, hidden: hidden, onChange: onChange);
}

class IntegerText extends PaddedText {
  @override
  TableColumnWidth get columnWidth => const FixedColumnWidth(32);

  static int _parseString(String string) {
    int? result = int.tryParse(string);
    return result ?? 0;
  }

  IntegerText(int? value,
      {Key? key,
      textAlign = TextAlign.center,
      TextStyle? style,
      bool hidden = false,
      bool editMode = false,
      Function(int)? onChange})
      : super(value != null ? value.toString() : "",
            key: key,
            textAlign: textAlign,
            style: style,
            hidden: hidden,
            editMode: editMode,
            keyboardType: TextInputType.number,
            maxLines: 1,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            onChange: (text)=>{onChange != null ? onChange(_parseString(text)) : {}});
}
