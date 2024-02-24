import 'package:flutter/material.dart';
import 'bluetooth_connection.dart';
import 'gloves_calibration.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  String? selectedLanguage;

  bool _isContainerVisible = false;

  void _toggleContainerVisibility() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic structure ogf the visual interface
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'lib/images/backgroundTranslation.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Info Button
          Positioned(
            top: 45,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GlovesCalibration()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF011F4B),
                shape: const CircleBorder(),
              ),
              child: Image.asset(
                'lib/images/settingsButton.png',
                width: 25,
                height: 25,
              ),
            ),
          ),
          //Connection
          Positioned(
            top: 53,
            left: 0,
            right: 220,
            child: Center(
              child: SizedBox(
                width: 150,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BluetoothConnect()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Not Connected',
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
          // Settings Button
          // Dropdown List
          Positioned(
            top: 240,
            left: 25,
            child: Container(
              width: 370,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: DropdownButton<String>(
                hint: const Text(
                    "    Select Language...                                                      ",
                    style: TextStyle(
                      fontFamily: 'Sans',
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    )),
                style: const TextStyle(
                  fontFamily: 'Sans',
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 16,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Colors.black,
                ),
                iconSize: 30,
                elevation: 16,
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(10),
                items: const [
                  DropdownMenuItem(
                    value: 'English',
                    child: Text('   English'),
                  ),
                  DropdownMenuItem(
                    value: 'Filipino',
                    child: Text('   Filipino'),
                  ),
                  DropdownMenuItem(
                    value: 'Korean',
                    child: Text('   Korean'),
                  ),
                  DropdownMenuItem(
                    value: 'Japanese',
                    child: Text('   Japanese'),
                  ),
                ],
                onChanged: (String? value) {
                  print('Selected language: $value');
                  setState(() {
                    // Assign the selected value to a variable to update the DropdownButton
                    selectedLanguage = value;
                  });
                },
                value: selectedLanguage,
              ),
            ),
          ),
          // Another Gradient Container
          Positioned(
            top: 290,
            left: 0,
            right: 0,
            child: ElevatedButton(
              onPressed: null,
              child: Container(
                width: 380,
                height: 200,
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
              ),
            ),
          ),
          // Translation Image
          Positioned(
            top: 870,
            left: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF011F4B),
                shape: const CircleBorder(),
              ),
              child: Image.asset(
                'lib/images/translationHome.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
          // History Button
          Positioned(
            top: 870,
            left: 290,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF011F4B),
                shape: const CircleBorder(),
              ),
              child: Image.asset(
                'lib/images/historyButton.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
          // Gloves Placeholder
          Positioned(
            top: 870,
            left: 165,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF011F4B),
                shape: const CircleBorder(),
              ),
              child: Image.asset(
                'lib/images/glovesPlaceholder.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
          // Horizontal Divider
          const Positioned(
            top: 850,
            left: 0,
            right: 0,
            child: Divider(
              color: Colors.white,
              thickness: 3,
            ),
          ),
          Positioned(
            top: 510,
            left: 25,
            child: Container(
              width: 370,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Positioned(
                child: Positioned(
                  top: 650,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _toggleContainerVisibility,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'M',
                          style: TextStyle(
                            fontFamily: 'Intro Rust',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          //BUTTON FOR HIDDEN CONTAINER

          //hidden container
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _isContainerVisible
                ? 570
                : 900, // Adjust these values as needed
            left: 50,
            right: 50,
            child: Visibility(
              visible: _isContainerVisible,
              child: Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFCDFFD8),
                      Color(0xFF94B9FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SPEECH TO TEXT HERE',
                    style: TextStyle(fontSize: 20),
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
