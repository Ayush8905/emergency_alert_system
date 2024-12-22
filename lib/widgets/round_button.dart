import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;// Declare title in the widget

  const RoundButton({Key? key,
    required this.title,
    required this.onTap
  }) : super(key: key);

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          widget.title, // Access title from the widget
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
