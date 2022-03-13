import 'package:flutter/material.dart';

class AlertTextField {}

void showAlert(
  String title,
  Function(String) onTextFieldChanged,
  Widget Function(BuildContext) screen,
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
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            child: const Text("Proceed"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: screen
              ));
            },
          ),
        ],
      );
    },
  );
}