import 'package:battle_it_out/entities_localisation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

class AlertTextField {}

void showAlert(
  String title,
  List<Tuple2<Function(String), Type>> fields,
  void Function() onProceedPressed,
  BuildContext context
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Column(children:[
          for (var field in fields)
            TextField(
              onChanged: (value) {
                field.item1(value);
              },
              keyboardType: field.item2 == int ? TextInputType.number : TextInputType.text,
              inputFormatters: field.item2 == int ? [FilteringTextInputFormatter.digitsOnly] : [],
              textAlign: TextAlign.center,
            )
        ]),
        actions: [
          TextButton(
            child: Text("CANCEL".localise(context)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("PROCEED".localise(context)),
            onPressed: onProceedPressed
          ),
        ],
      );
    },
  );
}