import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'bluetooth_connection.dart';
import 'gloves_calibration.dart';

//import 'package:SignSaya/services/ble_scan.dart'; changed to bluetooth_connection

import 'package:translator/translator.dart';

import 'package:SignSaya/pages/history_page.dart';

import 'package:SignSaya/pages/signsaya_database_config.dart';

import 'package:intl/intl.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  String? selectedLanguage; // pang stt
  SpeechToText _speechToText = SpeechToText(); // pang stt
  TextEditingController _speechController =
      TextEditingController(); // pang stt text fied controller

  TextEditingController _topTextController =
      TextEditingController(); // pang taas na text field controller

  //improved dropdown starts here
  String? selectedLanguageTop; // For top dropdown
  String? selectedLanguageBottom; // For bottom dropdown
  String translatedTextTop = ""; // For top dropdown translation
  String translatedTextBottom = ""; // For bottom dropdown translation
  //improved dropdown ends here

  // pang translation BEGINS here
  final translator = GoogleTranslator();

  // pang translation ENDS here

  void translateText(String input, String toLanguage, String dropdown) {
    translator.translate(input, to: toLanguage).then((result) {
      setState(() {
        if (dropdown == 'top') {
          translatedTextTop = result.text; // Update top dropdown translation
        } else {
          translatedTextBottom =
              result.text; // Update bottom dropdown translation
        }
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

    // String dropdownHintText =
    //     "${" " * (screenSize.width * 0.01).round()}Select Language...${" " * (screenSize.width * 0.093).round()}";

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const FBPMain(), // pang route sa history page
                      ),
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
          //PANGALAWANG DROPDOWN
          Positioned(
            top: screenSize.height * 0.56,
            left: screenSize.width * 0.05,
            child: Container(
              width: screenSize.width * 0.9,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text(
                    '  Select Language...', // Default hint text
                    style: TextStyle(
                      fontFamily: 'Sans',
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.grey, // Customize hint text color if needed
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Sans',
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  value: selectedLanguageBottom,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      // Check if newValue is not null
                      if (newValue != selectedLanguageBottom) {
                        setState(() {
                          selectedLanguageBottom = newValue;
                          translateText("", newValue,
                              'bottom'); // Update bottom dropdown translation
                        });
                      }
                    }
                  },
                  items: <String>['en', 'fil', 'ja', 'zh-cn']
                      .map<DropdownMenuItem<String>>((String value) {
                    String displayText = '';
                    switch (value) {
                      case 'en':
                        displayText = 'English';
                        break;
                      case 'fil':
                        displayText = 'Filipino';
                        break;
                      case 'ja':
                        displayText = 'Japanese';
                        break;
                      case 'zh-cn':
                        displayText = 'Mandarin Chinese';
                        break;
                      default:
                        displayText = '';
                    }
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(displayText),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          //UNANG DROPDOWN
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text(
                    '  Select Language...', // Default hint text
                    style: TextStyle(
                      fontFamily: 'Sans',
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.grey, // Customize hint text color if needed
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Sans',
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  value: selectedLanguageTop,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      // Check if newValue is not null
                      if (newValue != selectedLanguageTop) {
                        setState(() {
                          selectedLanguageTop = newValue;
                          translateText("", newValue,
                              'top'); // Update top dropdown translation
                        });
                      }
                    }
                  },
                  items: <String>['en', 'fil', 'ja', 'zh-cn']
                      .map<DropdownMenuItem<String>>((String value) {
                    String displayText = '';
                    switch (value) {
                      case 'en':
                        displayText = 'English';
                        break;
                      case 'fil':
                        displayText = 'Filipino';
                        break;
                      case 'ja':
                        displayText = 'Japanese';
                        break;
                      case 'zh-cn':
                        displayText = 'Mandarin Chinese';
                        break;
                      default:
                        displayText = '';
                    }
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(displayText),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Translation Container
          Positioned(
            top: gradientContainerTop,
            left: screenSize.width * 0.05,
            right: screenSize.width * 0.05,
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
                    controller: _topTextController,
                    decoration: const InputDecoration(
                      hintText: 'Enter text to translate',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      translateText(text, selectedLanguageTop ?? '',
                          'top'); // Update top dropdown translation
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.0355),
                  const Text(
                    'Translated Text:', // Update label to indicate top dropdown translation
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenSize.height * 0.0355),
                  Text(
                    translatedTextTop, // Display top dropdown translation
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenSize.height * 0.0355),
                  // const Text(
                  //   'Translated Text (Bottom Dropdown):', // Label for bottom dropdown translation
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 10),
                  // Text(
                  //   translatedTextBottom, // Display bottom dropdown translation
                  //   textAlign: TextAlign.center,
                  // ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const HistoryPage(), // pang route sa history page
                  ),
                );
              },
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
            top: hiddenContainerTop * 0.922,
            left: screenSize.width * 0.06,
            right: screenSize.width * 0.06,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: _isContainerVisible ? screenSize.height * 0.275 : 0,
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
                      translateText(text, selectedLanguageBottom ?? '',
                          'bottom'); // Update bottom dropdown translation
                    },
                  ),
                  //Save button for conversation
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: () async {
                        final DateFormat formatter = DateFormat('MM-dd-yyyy');
                        final String formattedDate =
                            formatter.format(DateTime.now());
                        final translation = {
                          'date': formattedDate,
                          'time': TimeOfDay.now().format(context),
                          'question': _topTextController.text,
                          'response': _speechController.text,
                          'translated_response': translatedTextBottom
                        };
                        await SignSayaDatabase().saveTranslation(translation);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Conversation Saved!'),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: const Text(
                        "SAVE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    right: screenSize.width * 0.025,
                    top: screenSize.height * 0.225,
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
                    bottom: screenSize.height * 0.01,
                    left: screenSize.width * 0.06,
                    right: screenSize.width * 0.06,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenSize.height * 0.0334),
                        const Text(
                          'Translated Text:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: screenSize.height * 0.0334),
                        Text(
                          translatedTextBottom, // Display bottom dropdown translation
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
