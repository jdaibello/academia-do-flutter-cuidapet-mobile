import 'package:flutter/material.dart';

class LoginRegisterButton extends StatelessWidget {
  const LoginRegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        Container(
          width: 163,
          height: 40,
          color: Colors.blue,
        ),
        Container(
          width: 163,
          height: 40,
          color: Colors.red,
        ),
        Container(
          width: 163,
          height: 40,
          color: Colors.green,
        ),
      ],
    );
  }
}
