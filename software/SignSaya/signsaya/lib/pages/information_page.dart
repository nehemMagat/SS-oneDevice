import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size; // Get screen size
    final double buttonWidth = screenSize.width * 0.8; // Calculate button width
    return Scaffold(
      // Display a scaffold
      body: Stack(
        // Stack to overlay widgets
        children: [
          // List of children widgets
          Image.asset(
            // Display background image
            'lib/images/informationPage.png', // Image asset path
            fit: BoxFit.cover, // Cover the entire screen
            width: double.infinity, // Set image width to fill the screen
            height: double.infinity, // Set image height to fill the screen
          ),
          Positioned(
            // Position the button at the bottom
            top: screenSize.height * 0.935, // Position from the top
            left: 0, // Align with the left edge
            right: 0, // Align with the right edge
            child: Center(
              // Center the button horizontally
              child: SizedBox(
                // Define a fixed-size box for the button
                width: buttonWidth * 0.65, // Set button width
                height: 35, // Set button height
                child: ElevatedButton(
                  // Display an ElevatedButton widget
                  onPressed: () {
                    // Define button onPressed callback
                    Navigator.pop(context); // Navigate back to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    // Define button style
                    shape: RoundedRectangleBorder(
                      // Apply rounded rectangle shape to button
                      borderRadius:
                          BorderRadius.circular(20), // Set border radius
                    ),
                  ),
                  child: const Text(
                    // Set button label text
                    'I UNDERSTAND', // Button label
                    style: TextStyle(
                      // Set text style
                      fontFamily: 'Intro Rust', // Set font family
                      fontWeight: FontWeight.bold, // Set font weight
                      fontSize: 10, // Set font size
                      color: Colors.black, // Set text color
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
