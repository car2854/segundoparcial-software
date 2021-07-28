
import 'package:flutter/cupertino.dart';

import '../config.dart';

class TittleContainer extends StatelessWidget {
  const TittleContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      height: 200,
      width: double.infinity,
      color: colorSecundario,
      child: Text(
        nameApp,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colorText,
          fontSize: 45
        ),
      ),
    );
  }
}


