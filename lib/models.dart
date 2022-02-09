import 'package:flutter/material.dart';

class LeftRow extends StatelessWidget {
  List<Widget> child;
  LeftRow(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 600,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: child));
  }
}

class RightRow extends StatelessWidget {
  List<Widget> child;
  RightRow(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: child));
  }
}
