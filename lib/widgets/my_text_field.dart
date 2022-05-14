import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user/theme/style.dart';

class MyTextField extends StatefulWidget {
  // Hint text for text field
  final String hintText;
  final key;
  // Callback functions
  final Function(String) onChanged;
  final Function(String) onSaved;
  final Function(String) onFieldSubmitted;

  // Other properties
  final TextInputType keyboardType;
  final double height;
  final String prefixText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Icon prefixIcon;
  final FontWeight inputTextFontWeight;
  final Widget suffixIcon;
  final Widget suffix;
  final Function onTap;
  final String initialText;
  final bool readOnly;
  final int maxLines;
  final int maxlength;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final List<TextInputFormatter> inputFormatters;
  final bool obscureText;
  final String obscuringCharacter;

  // Constructor of text field
  MyTextField(this.key, {this.onSaved, this.inputTextFontWeight, this.onTap, this.prefixText, this.prefixIcon, this.textCapitalization, this.maxLines, this.controller, this.height, this.readOnly, this.suffixIcon, this.initialText, this.inputFormatters, this.onChanged, this.hintText, this.keyboardType, this.autofocus, this.obscureText, this.maxlength, this.focusNode, this.onFieldSubmitted, this.obscuringCharacter, this.suffix}) : super();
  @override
  _MyTextFieldState createState() => _MyTextFieldState(hintText: hintText, height: height, textCapitalization: textCapitalization, suffixIcon: suffixIcon, readOnly: readOnly, prefixIcon: prefixIcon, maxLines: maxLines, keyboardType: keyboardType, inputFormatters: inputFormatters, initialText: initialText, controller: controller, autofocus: autofocus, onSaved: onSaved, obscureText: obscureText, onTap: onTap, onChanged: onChanged, inputTextFontWeight: inputTextFontWeight, maxlength: maxlength, prefixText: prefixText, focusNode: focusNode, onFieldSubmitted: onFieldSubmitted, obscuringCharacter: obscuringCharacter, key: key, suffix: suffix);
}

class _MyTextFieldState extends State<MyTextField> {
  var key;
  String hintText;
  FocusNode focusNode;
  Function(String) onChanged;
  Function(String) onSaved;
  TextInputType keyboardType;
  double height;
  String prefixText;
  TextEditingController controller;
  Icon prefixIcon;
  FontWeight inputTextFontWeight;
  Widget suffixIcon;
  Function onTap;
  String initialText;
  bool readOnly;
  int maxLines;
  int maxlength;
  Widget suffix;
  TextCapitalization textCapitalization;
  bool autofocus;
  List<TextInputFormatter> inputFormatters;
  bool obscureText;
  Function(String) onFieldSubmitted;
  String obscuringCharacter;
  bool _obscureText;

  _MyTextFieldState({this.onSaved, this.inputTextFontWeight, this.onTap, this.prefixText, this.prefixIcon, this.textCapitalization, this.maxLines, this.controller, this.height, this.readOnly, this.suffixIcon, this.initialText, this.inputFormatters, this.onChanged, this.hintText, this.keyboardType, this.autofocus, this.obscureText, this.maxlength, this.focusNode, this.onFieldSubmitted, this.obscuringCharacter, this.key, this.suffix});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      cursorColor: Colors.black,
      controller: controller,
      style: textFieldInputStyle(context, inputTextFontWeight),
      keyboardType: keyboardType ?? TextInputType.text,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      obscureText: _obscureText,
      autofocus: autofocus ?? false,
      readOnly: readOnly ?? false,
      maxLines: maxLines ?? 1,
      initialValue: initialText,
      maxLength: maxlength,
      onTap: onTap,
      focusNode: focusNode,
      obscuringCharacter: '*',
      inputFormatters: inputFormatters ?? [],
      decoration: InputDecoration(
        suffix: suffix,
        prefixText: prefixText,
        prefixStyle: textFieldInputStyle(context, inputTextFontWeight),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.7,
            color: Colors.black,
          ),
        ),
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: textFieldHintStyle(context),
      ),
      onFieldSubmitted: onFieldSubmitted != null ? (val) => onFieldSubmitted(val) : null,
      onChanged: onChanged != null ? (value) => onChanged(value) : null,
      onSaved: (value) => onSaved(value),
    );
  }

  @override
  void initState() {
    super.initState();
    if (obscureText != null) {
      _obscureText = obscureText;
    } else {
      _obscureText = false;
    }
  }
}
