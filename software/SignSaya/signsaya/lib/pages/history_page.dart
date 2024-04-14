import 'package:flutter/material.dart';
import 'package:SignSaya/pages/signsaya_database_config.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double headerWidth = screenSize.width * 0.12;

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
                'Error: ${snapshot.error}',
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
                  padding: EdgeInsets.only(top: screenSize.height * 0.23),
                  child: DataTable(
                    columnSpacing: 0, // Adjust column spacing
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: headerWidth,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  0), // Adjust header padding here
                              child: Text(
                                'Number',
                                style: TextStyle(
                                    fontFamily: 'Intro Rust',
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: headerWidth * 0.88,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  0), // Adjust header padding here
                              child: Text(
                                'Date',
                                style: TextStyle(
                                    fontFamily: 'Intro Rust',
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        tooltip: 'Date',
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: headerWidth,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  0), // Adjust header padding here
                              child: Text(
                                'Time',
                                style: TextStyle(
                                    fontFamily: 'Intro Rust',
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        tooltip: 'Time',
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: screenSize.width * 0.15,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  0), // Adjust header padding here
                              child: Text(
                                'Question',
                                style: TextStyle(
                                    fontFamily: 'Intro Rust',
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        tooltip: 'Question',
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: screenSize.width * 0.18,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  4.0), // Adjust header padding here
                              child: Text(
                                'Response',
                                style: TextStyle(
                                    fontFamily: 'Intro Rust',
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        tooltip: 'Response',
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: screenSize.width * 0.22,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  4.0), // Adjust header padding here
                              child: Text(
                                'Translated \nResponse',
                                style: TextStyle(
                                    fontFamily: 'Intro Rust',
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        tooltip: 'Translated Response',
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: screenSize.width * 0.04,
                          child: SizedBox(), // Empty cell for the last column
                        ),
                      ),
                    ],
                    rows: [], // Empty rows for now
                  ),
                ),
                Padding(
                  padding: /*EdgeInsets.only(
                      top: screenSize.height * 0.2 +
                          48.0), */ // Adjust top padding accordingly
                      EdgeInsets.fromLTRB(
                    0, // left
                    screenSize.height * 0.2 + 48.0, // top
                    0, // right
                    screenSize.height * 0.1, // bottom
                  ),
                  child: SizedBox(
                    width: screenSize.width,
                    height:
                        screenSize.height - (screenSize.height * 0.2 + 49.0),
                    child: ListView.builder(
                      itemCount: translations.length,
                      itemBuilder: (context, index) {
                        final translation = translations[index];
                        return Row(
                          children: [
                            SizedBox(
                              width: headerWidth,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      4.0), // Adjust cell padding here
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        fontFamily: 'Intro Rust',
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: headerWidth,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      4.0), // Adjust cell padding here
                                  child: Text(
                                    translation['date'],
                                    style: TextStyle(
                                        fontFamily: 'Intro Rust',
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: headerWidth,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      4.0), // Adjust cell padding here
                                  child: Text(
                                    translation['time'],
                                    style: TextStyle(
                                        fontFamily: 'Intro Rust',
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.2,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      4.0), // Adjust cell padding here
                                  child: Text(
                                    translation['question'],
                                    style: TextStyle(
                                        fontFamily: 'Intro Rust',
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.2,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      4.0), // Adjust cell padding here
                                  child: Text(
                                    translation['response'],
                                    style: TextStyle(
                                        fontFamily: 'Intro Rust',
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.2,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      4.0), // Adjust cell padding here
                                  child: Text(
                                    translation['translated_response'],
                                    style: TextStyle(
                                        fontFamily: 'Intro Rust',
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
}
