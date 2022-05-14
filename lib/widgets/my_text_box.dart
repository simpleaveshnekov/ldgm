import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user/theme/style.dart';

class MyTextBox extends StatefulWidget {
  // Hint text for text field
  final String hintText;

  // Callback functions
  final Function(String) onChanged;
  final Function(String) onFieldSubmitted;
  final Function onEditingComplete;
  final Function(String) onSaved;

  // Other properties
  final TextInputType keyboardType;
  final double height;
  final TextEditingController controller;
  final Icon prefixIcon;
  final Widget suffixIcon;
  final Function onTap;
  final String initialText;
  final bool readOnly;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final List<TextInputFormatter> inputFormatters;
  final bool obscureText;
  final key;

  // Constructor of text field
  MyTextBox({this.onSaved, this.onTap, this.prefixIcon, this.textCapitalization, this.maxLines, this.onEditingComplete, this.controller, this.height, this.readOnly, this.suffixIcon, this.initialText, this.inputFormatters, this.onChanged, this.hintText, this.keyboardType, this.autofocus, this.obscureText, this.key, this.onFieldSubmitted}) : super();
  @override
  _MyTextBoxState createState() => _MyTextBoxState(height: height, hintText: hintText, onChanged: onChanged, onTap: onTap, obscureText: obscureText, onEditingComplete: onEditingComplete, onSaved: onSaved, autofocus: autofocus, controller: controller, initialText: initialText, inputFormatters: inputFormatters, keyboardType: keyboardType, maxLines: maxLines, prefixIcon: prefixIcon, readOnly: readOnly, suffixIcon: suffixIcon, textCapitalization: textCapitalization, key: key, onFieldSubmitted: onFieldSubmitted);
}

class _MyTextBoxState extends State<MyTextBox> {
  String hintText;
  Function(String) onChanged;
  Function onEditingComplete;
  Function(String) onSaved;
  TextInputType keyboardType;
  double height;
  TextEditingController controller;
  Icon prefixIcon;
  Widget suffixIcon;
  Function onTap;
  String initialText;
  bool readOnly;
  int maxLines;
  TextCapitalization textCapitalization;
  bool autofocus;
  List<TextInputFormatter> inputFormatters;
  bool obscureText;
  var key;
  Function(String) onFieldSubmitted;

  // Constructor of text field
  _MyTextBoxState({this.onSaved, this.onTap, this.prefixIcon, this.textCapitalization, this.maxLines, this.onEditingComplete, this.controller, this.height, this.readOnly, this.suffixIcon, this.initialText, this.inputFormatters, this.onChanged, this.hintText, this.keyboardType, this.autofocus, this.obscureText, this.key, this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        key: key,
        cursorColor: Colors.grey[800],
        controller: controller,
        style: textFieldHintStyle(context),
        keyboardType: keyboardType ?? TextInputType.text,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        obscureText: obscureText ?? false,
        autofocus: autofocus ?? false,
        readOnly: readOnly ?? false,
        maxLines: maxLines ?? 1,
        initialValue: initialText,
        onTap: onTap,
        inputFormatters: inputFormatters ?? [],
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(width: 0, color: Theme.of(context).colorScheme.secondary, style: BorderStyle.none),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(width: 0, color: Theme.of(context).colorScheme.secondary, style: BorderStyle.none),
          ),
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintStyle: textFieldHintStyle(context),
          contentPadding: EdgeInsets.only(bottom: 12.0),
        ),
        onSaved: (value) => onSaved(value),
        onEditingComplete: () => onEditingComplete(),
        onFieldSubmitted: onFieldSubmitted != null ? (val) => val != null && val != "" ? onFieldSubmitted(val) : null : null,
        onChanged: onChanged != null ? (value) => onChanged(value) : null,
      ),
    );
  }
}
