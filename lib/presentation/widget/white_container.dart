import 'package:flutter/material.dart';

class WhiteContainer extends StatelessWidget {
  final String headerText;
  final String labelText;
  final Widget child;

  const WhiteContainer(
      {Key? key,
      required this.headerText,
      required this.labelText,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        alignment: Alignment.topLeft,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerText,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              labelText,
              style: const TextStyle(color: Colors.black87, fontSize: 15.5),
            ),
            const SizedBox(
              height: 20,
            ),
            child,
            const SizedBox(height: 270),
          ],
        ),
      ),
    );
  }
}
