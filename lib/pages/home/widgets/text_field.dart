import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final String prefix;
  final TextEditingController controller;
  final Function function;

  const TextFieldWidget(
      {Key key, this.label, this.prefix, this.controller, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
        ),
        border: OutlineInputBorder(),
        prefixText: prefix,
      ),
      style: TextStyle(
        color: Colors.amber,
        fontSize: 25,
      ),
      onChanged: function,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }
}
