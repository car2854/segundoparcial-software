
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class FormText extends StatelessWidget {

  final TextEditingController textController;
  final bool isPassword;
  final String nameText;

  const FormText({
    Key? key, 
    required this.textController, 
    this.isPassword = false, 
    required this.nameText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: TextFormField(
        
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorText)
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorText)
          ),
          labelText: this.nameText,
          // errorText: (this.textController.text.trim().length > 0)? null: "Este campo es obligatorio",
          labelStyle: TextStyle(
            color: colorText,
            fontWeight: FontWeight.bold,
            fontSize: 20
          )
        ),
        style: TextStyle(
          color: colorText
        ),
        obscureText: this.isPassword,
        controller: this.textController,
        validator: (value) {
          print(value);
          if (value == null || value.isEmpty){
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }
}