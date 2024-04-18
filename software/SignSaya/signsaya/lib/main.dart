// Import necessary packages and files
import 'package:SignSaya/pages/information_page.dart'; // Importing the information page file
import 'package:flutter/material.dart'; // Importing the Material package from Flutter
import 'pages/translation_page.dart'; // Importing the translation page file
import 'package:permission_handler/permission_handler.dart'; // Importing the permission_handler package

void main() async {
  // Main function of the app
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter bindings are initialized

  // Initialize permissions before running the app
  await _initPermissions(); // Using 'await' because '_initPermissions' returns a Future

  // Run the application
  runApp(const MyApp());
}

// Function to initialize permissions
Future<void> _initPermissions() async {
  // 'async' allows the function to use 'await' inside it
  // Request microphone permission
  var status = await Permission.microphone
      .request(); // 'await' waits for the permission request to complete
  if (status.isGranted) {
    // Checking if the permission is granted
    print(
        "Microphone permission granted"); // Print a message if permission is granted
  } else {
    print(
        "Microphone permission denied"); // Print a message if permission is denied
    // Handle permission denial
  }
}

// Define the main application widget
class MyApp extends StatelessWidget {
  // Definition of the main application widget
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Building the application UI
    return const MaterialApp(
      // Creating a MaterialApp widget
      home: MyHomePage(), // Setting the home page to MyHomePage
    );
  }
}

// Define the home page of the application
class MyHomePage extends StatelessWidget {
  // Definition of the home page widget
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Building the UI for the home page
    // Get the screen size
    final Size screenSize =
        MediaQuery.of(context).size; // Getting the size of the screen

    // Calculate button dimensions based on screen size
    final double buttonWidth =
        screenSize.width * 0.8; // Calculating button width
    final double buttonHeight = 50; // Setting button height
    final double infoButtonSize =
        screenSize.width * 0.07; // Calculating info button size

    return Scaffold(
      // Returning a Scaffold widget for the UI layout
      body: Stack(
        // Using a Stack layout to overlay widgets
        children: [
          // List of widgets in the stack
          // Background image
          Image.asset(
            // Adding a background image
            'lib/images/backgroundHome.png', // Image file path
            fit: BoxFit.cover, // Cover the entire screen with the image
            width: screenSize.width, // Set image width to screen width
            height: screenSize.height, // Set image height to screen height
          ),
          // Information button
          Positioned(
            // Positioning the information button
            top: screenSize.height *
                0.06, // Setting the top position of the button
            right: screenSize.width *
                0.03, // Setting the right position of the button
            child: ElevatedButton(
              // Creating an ElevatedButton widget
              onPressed: () {
                // Handling button press
                // Navigate to the information page when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const InformationPage(), // Navigate to the InformationPage widget
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                // Styling the button
                backgroundColor:
                    const Color(0xFF011F4B), // Setting button background color
                shape: const CircleBorder(), // Making button circular
              ),
              child: Image.asset(
                // Adding an image inside the button
                'lib/images/infoButton.png', // Image file path
                width: infoButtonSize, // Setting image width
                height: infoButtonSize, // Setting image height
              ),
            ),
          ),
          // "Get Started" button
          Positioned(
            // Positioning the "Get Started" button
            top: screenSize.height *
                0.8, // Setting the top position of the button
            left: screenSize.width *
                0.1, // Setting the left position of the button
            right: screenSize.width *
                0.1, // Setting the right position of the button
            child: Center(
              // Centering the button horizontally
              child: SizedBox(
                // Adding a SizedBox to constrain button dimensions
                width: buttonWidth, // Setting button width
                height: buttonHeight, // Setting button height
                child: ElevatedButton(
                  // Creating an ElevatedButton widget
                  onPressed: () {
                    // Handling button press
                    // Navigate to the translation page when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const TranslationPage(), // Navigate to the TranslationPage widget
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // Styling the button
                    shape: RoundedRectangleBorder(
                      // Adding rounded corners to the button
                      borderRadius:
                          BorderRadius.circular(20), // Setting border radius
                    ),
                  ),
                  child: const Text(
                    // Adding text inside the button
                    'GET STARTED', // Button text
                    style: TextStyle(
                      // Styling the text
                      fontFamily: 'Intro Rust', // Setting font family
                      fontWeight: FontWeight.bold, // Setting font weight
                      fontSize: 30, // Setting font size
                      color: Colors.black, // Setting text color
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
