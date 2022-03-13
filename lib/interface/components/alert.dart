import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlertTextField {}

void showAlert(
  String title,
  Function(String) onTextFieldChanged,
  Type textFieldType,
  void Function() onProceedPressed,
  BuildContext context
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          onChanged: (value) {
            onTextFieldChanged(value);
          },
          keyboardType: textFieldType == int ? TextInputType.number : TextInputType.text,
          inputFormatters: textFieldType == int ? [FilteringTextInputFormatter.digitsOnly] : [],
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Proceed"),
            onPressed: onProceedPressed
          ),
        ],
      );
    },
  );
}