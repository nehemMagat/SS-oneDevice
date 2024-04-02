import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double buttonWidth = screenSize.width * 0.8;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'lib/images/informationPage.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: screenSize.height * 0.935,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: buttonWidth * 0.65,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'I UNDERSTAND',
                    style: TextStyle(
                      fontFamily: 'Intro Rust',
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
