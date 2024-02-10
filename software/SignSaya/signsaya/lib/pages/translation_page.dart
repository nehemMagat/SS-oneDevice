import 'package:flutter/material.dart';

class TranslationPage extends StatelessWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic structure of the visual interface
    return Scaffold(
      body: Stack(
        children: [
          // Background container with gradient color
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFCDFFD8), Color(0xFF94B9FF)],
              ),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align text at the top
              children: [
                const SizedBox(height: 50), // Add spacing at the top

                // Application title
                const Text(
                  "SignSaya",
                  style: TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 90,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  width: 350, // Adjust the width as needed
                  child: Text(
                    // Application description
                    "Bridging Communication Gaps for Deaf and Mute Filipino Travelers through mobile Filipino Sign Language interpretation",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Expanded widget takes all available vertical space
                Expanded(
                  child: Container(),
                ),

                // Button to navigate to BtConnectPage
                ElevatedButton(
                  onPressed: () {
                    // Navigate to BtConnectPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BtConnectPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF011F4B),
                    shape: const CircleBorder(),
                  ),
                  child: Image.asset(
                    'lib/images/buttonImage.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 300), // Add spacing at the bottom
              ],
            ),
          ),

          // Image at the bottom right corner
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'lib/images/estetikBot.png',
                width: 300, // Set the width of the image
                height: 300, // Set the height of the image
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Copyright text in the far left corner
          const Positioned(
            bottom: 16.0, // Adjust the top offset as needed
            left: 16.0, // Adjust the left offset as needed
            child: Text(
              "© 2023 SignSaya. All Rights Reserved.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
