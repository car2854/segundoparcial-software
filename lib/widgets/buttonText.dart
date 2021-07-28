
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class ButtonText extends StatelessWidget {

  final String text;
  final String accion;

  const ButtonText({
    Key? key, 
    required this.text, 
    required this.accion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 7),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, this.accion);
        },
        child: Text(
          this.text,
          style: TextStyle(
            color: colorText,
            fontSize: 15
          ),
        ),
      ),
    );
  }
}