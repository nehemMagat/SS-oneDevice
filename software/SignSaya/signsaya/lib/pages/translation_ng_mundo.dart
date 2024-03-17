import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;

  const GradientText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFCDFFD8),
            Color(0xFF94B9FF),
          ],
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
