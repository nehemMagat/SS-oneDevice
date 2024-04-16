import 'package:flutter/material.dart';
import 'package:SignSaya/pages/signsaya_database_config.dart';
import 'package:SignSaya/pages/view_history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: SignSayaDatabase().getAllTranslations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching data. Please try again later.',
                style: TextStyle(fontFamily: 'Intro Rust', color: Colors.white),
              ),
            );
          } else {
            final translations = snapshot.data!;
            return Stack(
              children: [
                Image.asset(
                  'lib/images/backgroundTranslation.png',
                  fit: BoxFit.cover,
                  width: screenSize.width,
                  height: screenSize.height,
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.25),
                  child: Column(
                    children: [
                      _buildHeaderRow(screenSize),
                      SizedBox(
                        height: screenSize.height *
                            0.6149, // Set a fixed height for the SizedBox
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: translations.map((translation) {
                                  return _buildDataRow(context, screenSize,
                                      translations, translation);
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenSize.height * 0.92,
                  left: screenSize.width * 0.38,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF011F4B),
                      shape: const CircleBorder(),
                    ),
                    child: Image.asset(
                      'lib/images/historyBack.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildHeaderRow(Size screenSize) {
    final double headerWidth = screenSize.width * 0.12;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white),
          top: BorderSide(color: Colors.white),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: headerWidth * 1.5,
            height: screenSize.height * 0.05,
            child: const Center(
              child: Text(
                'Date',
                style: TextStyle(
                  fontFamily: 'Intro Rust',
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: headerWidth * 4,
            child: const Center(
              child: Text(
                'Question',
                style: TextStyle(
                  fontFamily: 'Intro Rust',
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            child: Center(
              child: Text(
                '',
                style: TextStyle(
                  fontFamily: 'Intro Rust',
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: screenSize.width * 0.04),
        ],
      ),
    );
  }

  Widget _buildDataRow(
      BuildContext context,
      Size screenSize,
      List<Map<String, dynamic>> translations,
      Map<String, dynamic> translation) {
    final double headerWidth = screenSize.width * 0.12;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: headerWidth * 1.5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  translation['date'],
                  style: const TextStyle(
                    fontFamily: 'Intro Rust',
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: headerWidth * 3.8,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  translation['question'],
                  style: const TextStyle(
                    fontFamily: 'Intro Rust',
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: screenSize.width * 0.3,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewHistoryPage(
                      number: translation['id'],
                      date: translation['date'],
                      time: translation['time'],
                      question: translation['question'],
                      response: translation['response'],
                      translatedResponse: translation['translated_response'],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize:
                    Size(screenSize.width * 0.25, 35), // Adjust button size
              ),
              child: const Text(
                'Tap to View',
                style: TextStyle(
                  fontFamily: 'Intro Rust',
                  fontSize: 10,
                  color: Color.fromARGB(255, 0, 16, 29),
                ),
              ),
            ),
          ),
          SizedBox(width: screenSize.width * 0.04),
        ],
      ),
    );
  }
}
