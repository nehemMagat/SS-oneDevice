import 'package:flutter/material.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  String? selectedLanguage;

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
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF011F4B),
                shape: const CircleBorder(),
              ),
              child: Image.asset(
                'lib/images/infoButton.png',
                width: 25,
                height: 25,
              ),
            ),
          ),
          // Settings Button
          Positioned(
            top: 45,
            left: 0,
            child: ElevatedButton(
              onPressed: null,
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
          // Dropdown List
          Positioned(
            top: 230,
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
            top: 280,
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
        ],
      ),
    );
  }
}
