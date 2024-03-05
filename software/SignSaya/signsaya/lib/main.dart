import 'package:SignSaya/pages/information_page.dart';
import 'package:flutter/material.dart';
import 'pages/translation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate the values based on screen size
    final double buttonWidth = screenSize.width * 0.8;
    final double buttonHeight = 50;
    final double infoButtonSize = screenSize.width * 0.07;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'lib/images/backgroundHome.png',
            fit: BoxFit.cover,
            width: screenSize.width,
            height: screenSize.height,
          ),
          // information button
          Positioned(
            top: screenSize.height * 0.06,
            right: screenSize.width * 0.03,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InformationPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF011F4B),
                shape: const CircleBorder(),
              ),
              child: Image.asset(
                'lib/images/infoButton.png',
                width: infoButtonSize,
                height: infoButtonSize,
              ),
            ),
          ),
          // Get Started na bttn
          Positioned(
            top: screenSize.height * 0.8,
            left: screenSize.width * 0.1,
            right: screenSize.width * 0.1,
            child: Center(
              child: SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TranslationPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Get TITE',
                    style: TextStyle(
                      fontFamily: 'Intro Rust',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
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
