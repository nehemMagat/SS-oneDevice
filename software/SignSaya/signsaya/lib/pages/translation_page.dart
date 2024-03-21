import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'bluetooth_connection.dart';
import 'gloves_calibration.dart';

import 'package:SignSaya/services/ble_scan.dart';

import 'package:translator/translator.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  String? selectedLanguage; // pang stt
  SpeechToText _speechToText = SpeechToText(); // pang stt
  TextEditingController _speechController = TextEditingController(); // pang stt

  // pang translation BEGINS here
  final translator = GoogleTranslator();
  String translatedText = "";
  String translationDesiredLang = "en";

  // pang translation ENDS here

  void translateText(String input, String toLanguage) {
    translator.translate(input, to: toLanguage).then((result) {
      setState(() {
        translatedText = result.text; // Accessing text property
      });
    });
  }

  bool _isContainerVisible = false;

  void _toggleContainerVisibility() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _initSpeech(); // pang stt
  }

  // stt functions BEGINS here
  void _initSpeech() async {
    _speechToText.initialize(onError: (error) => print('Error: $error'));
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _speechController.text = result.recognizedWords;
    });
  }

  // stt functions ENDS here

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate positions based on screen size
    final double infoButtonTop = screenSize.height * 0.04;
    final double connectionButtonTop = screenSize.height * 0.053;
    final double dropdownContainerTop = screenSize.height * 0.253;
    final double gradientContainerTop = screenSize.height * 0.3;
    final double translationImageTop = screenSize.height * 0.87;
    final double buttonsRowTop = screenSize.height * 0.855;
    final double hiddenContainerTop = screenSize.height * 0.66;

    String dropdownHintText =
        "${" " * (screenSize.width * 0.01).round()}Select Language...${" " * (screenSize.width * 0.093).round()}";

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'lib/images/backgroundTranslation.png',
            fit: BoxFit.cover,
            width: screenSize.width,
            height: screenSize.height,
          ),
          // Calibration Button
          Positioned(
            top: infoButtonTop,
            right: screenSize.width * 0.02,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GlovesCalibration()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF011F4B),
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
            top: connectionButtonTop,
            left: screenSize.width * 0.02,
            right: screenSize.width * 0.6,
            child: Center(
              child: SizedBox(
                width: 150,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const BluetoothConnect()),
                    // );
                    begin();
                    scan();

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
          // PANGALAWANG TRANSLATION
          Positioned(
            top: screenSize.height * 0.539,
            left: screenSize.width * 0.05,
            child: Container(
              width: screenSize.width * 0.9,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: DropdownButton<String>(
                hint: Text(
                  dropdownHintText,
                  style: const TextStyle(
                    fontFamily: 'Sans',
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Sans',
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 16,
                ),
                value: translationDesiredLang,
                onChanged: (String? newValue) {
                  // Change the parameter type to String?
                  if (newValue != null) {
                    // Check if newValue is not null
                    setState(() {
                      translationDesiredLang = newValue;
                      translateText(
                          "", translationDesiredLang); // Clear translated text
                    });
                  }
                },
                items: <String>['en', 'fil', 'ja', 'zh-cn']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),

          Positioned(
            top: dropdownContainerTop,
            left: screenSize.width * 0.05,
            child: Container(
              width: screenSize.width * 0.9,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: DropdownButton<String>(
                hint: Text(
                  dropdownHintText,
                  style: const TextStyle(
                    fontFamily: 'Sans',
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Sans',
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 16,
                ),
                value: translationDesiredLang,
                onChanged: (String? newValue) {
                  // Change the parameter type to String?
                  if (newValue != null) {
                    // Check if newValue is not null
                    setState(() {
                      translationDesiredLang = newValue;
                      translateText(
                          "", translationDesiredLang); // Clear translated text
                    });
                  }
                },
                items: <String>['en', 'fil', 'ja', 'zh-cn']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),

          // Translation Container
          Positioned(
            top: gradientContainerTop,
            left: screenSize.width * 0.01,
            right: screenSize.width * 0.01,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFCDFFD8),
                    Color(0xFF94B9FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter text to translate',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      translateText(text, translationDesiredLang);
                    },
                  ),
                  const SizedBox(height: 80),
                  const Text(
                    'Translated Text:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    translatedText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Translation Image
          Positioned(
            top: translationImageTop * 1.05,
            left: screenSize.width * 0.05,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF011F4B),
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
            top: translationImageTop * 1.05,
            left: screenSize.width * 0.68,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF011F4B),
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
            top: translationImageTop * 1.05,
            left: screenSize.width * 0.38,
            child: ElevatedButton(
              onPressed: _toggleContainerVisibility,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF011F4B),
                shape: const CircleBorder(),
              ),
              child: Image.asset(
                'lib/images/micBttn.png',
                width: 45,
                height: 45,
              ),
            ),
          ),
          // Horizontal Divider
          Positioned(
            top: buttonsRowTop * 1.04,
            left: 0,
            right: 0,
            child: const Divider(
              color: Colors.white,
              thickness: 3,
            ),
          ),
          // YUNG LUMILITAW
          Positioned(
            top: hiddenContainerTop * 0.877,
            left: screenSize.width * 0.06,
            right: screenSize.width * 0.06,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: _isContainerVisible ? screenSize.height * 0.304 : 0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFCDFFD8),
                    Color(0xFF94B9FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: _speechController,
                    decoration: InputDecoration(
                      hintText: 'Tap the Microphone to Start Speech to Text',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                      contentPadding: const EdgeInsets.all(20.0),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: _speechToText.isListening
                            ? _stopListening
                            : _startListening,
                        icon: Icon(_speechToText.isListening
                            ? Icons.mic_off
                            : Icons.mic),
                      ),
                    ),
                    maxLines: null,
                    onChanged: (text) {
                      translateText(text,
                          translationDesiredLang); // Translate as text changes
                    },
                  ),
                  Positioned(
                    right: 12.0,
                    top: 350.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _speechController.clear();
                        });
                      },
                      child: const Icon(Icons.delete,
                          color: Colors.black, size: 30),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Translated Text:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          translatedText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Text Display for Speech Recognition
          // Positioned(
          //   top: hiddenContainerTop * 0.277,
          //   left: screenSize.width * 0.06,
          //   right: screenSize.width * 0.06,
          //   child: AnimatedContainer(
          //     duration: const Duration(milliseconds: 500),
          //     curve: Curves.easeInOut,
          //     height: _isContainerVisible ? screenSize.height * 0.304 : 0,
          //     decoration: BoxDecoration(
          //       gradient: const LinearGradient(
          //         begin: Alignment.centerLeft,
          //         end: Alignment.centerRight,
          //         colors: [
          //           Color(0xFFCDFFD8),
          //           Color(0xFF94B9FF),
          //         ],
          //       ),
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.3),
          //           spreadRadius: 2,
          //           blurRadius: 5,
          //           offset: const Offset(0, 3),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
