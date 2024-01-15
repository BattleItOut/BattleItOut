import 'package:flutter/material.dart';

class EditableTable extends StatefulWidget {
  final List header;
  final List data;
  final List? enabled;
  final void Function(List editedList)? onChanged;

  const EditableTable({super.key, required this.header, required this.data, this.onChanged, this.enabled});
  EditableTable.from({key, data, onChanged, enabled})
      : this(key: key, header: data[0], data: data[1], onChanged: onChanged, enabled: enabled);

  @override
  State<EditableTable> createState() => _EditableTableState();
}

class _EditableTableState extends State<EditableTable> {
  List editedData = [];

  @override
  void initState() {
    super.initState();
    editedData = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Widget generateHeaders() {
      return Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
        child: Row(
          children: List<Widget>.generate(widget.header.length, (index) {
            return Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / widget.header.length,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.header[index],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }

    List<Widget> generateRows() {
      return List<Widget>.generate(widget.data.length, (index) {
        return Row(
          children: List.generate(widget.header.length, (rowIndex) {
            var list = widget.data[index];
            return Flexible(
              fit: FlexFit.loose,
              flex: 6,
              child: Container(
                width: MediaQuery.of(context).size.width / widget.header.length,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5)),
                child: widget.enabled?[index][rowIndex] != false
                    ? Container(
                        alignment: Alignment.center,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          initialValue: list[rowIndex].toString(),
                          onChanged: (value) {
                            editedData[index][rowIndex] = value;
                            widget.onChanged!.call(editedData);
                          },
                          decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: Text(list[rowIndex].toString(), textAlign: TextAlign.center),
                      ),
              ),
            );
          }),
        );
      });
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        generateHeaders(),
        ...generateRows(),
      ]),
    );
  }
}
