import 'package:flutter/material.dart';

class CustomTag extends StatelessWidget {
  final String? title;
  CustomTag({this.title});

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: EdgeInsets.only(
            left: 5.0
        ),
        width: 100.0,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title ?? "Branded",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
  }
}
