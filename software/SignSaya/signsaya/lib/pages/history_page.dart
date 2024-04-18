import 'package:flutter/material.dart'; // Importing the Material package from Flutter
import 'package:SignSaya/pages/signsaya_database_config.dart'; // Importing database configuration file
import 'package:SignSaya/pages/view_history.dart'; // Importing view history page

class HistoryPage extends StatelessWidget {
  // Definition of the history page widget
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Building the UI for the history page
    final Size screenSize =
        MediaQuery.of(context).size; // Getting the size of the screen

    return Scaffold(
      // Returning a Scaffold widget for the UI layout
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Using FutureBuilder to handle asynchronous data loading
        future: SignSayaDatabase()
            .getAllTranslations(), // Getting all translations from the database
        builder: (context, snapshot) {
          // Building UI based on the snapshot of the future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Checking if data is still loading
            return const Center(
              // Showing a loading indicator if data is still loading
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handling error if data loading fails
            return Center(
              // Showing an error message if data loading fails
              child: Text(
                'Error fetching data. Please try again later.',
                style: TextStyle(fontFamily: 'Intro Rust', color: Colors.white),
              ),
            );
          } else {
            // Displaying the data if loaded successfully
            final translations =
                snapshot.data!; // Getting the list of translations

            return Stack(
              // Using a Stack layout to overlay widgets
              children: [
                // List of widgets in the stack
                Image.asset(
                  // Adding a background image
                  'lib/images/backgroundTranslation.png', // Image file path
                  fit: BoxFit.cover, // Cover the entire screen with the image
                  width: screenSize.width, // Set image width to screen width
                  height:
                      screenSize.height, // Set image height to screen height
                ),
                Padding(
                  // Adding padding to the column
                  padding: EdgeInsets.only(
                      top: screenSize.height * 0.25), // Setting top padding
                  child: Column(
                    // Creating a column to display translations
                    children: [
                      _buildHeaderRow(screenSize), // Building the header row
                      SizedBox(
                        // Adding a SizedBox to constrain the size of the ListView
                        height: screenSize.height *
                            0.6149, // Set a fixed height for the SizedBox
                        child: SingleChildScrollView(
                          // Making the ListView scrollable
                          child: Column(
                            // Creating a column inside the SingleChildScrollView
                            children: [
                              ListView(
                                // Creating a ListView to display translations
                                padding:
                                    EdgeInsets.zero, // Setting padding to zero
                                shrinkWrap:
                                    true, // Allowing the ListView to shrink-wrap its content
                                physics:
                                    const NeverScrollableScrollPhysics(), // Disabling scrolling
                                children: translations.map((translation) {
                                  // Mapping translations to widgets
                                  return _buildDataRow(
                                      context,
                                      screenSize,
                                      translations,
                                      translation); // Building data rows
                                }).toList(), // Converting mapped widgets to a list
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  // Positioning the back button
                  top: screenSize.height *
                      0.92, // Setting the top position of the button
                  left: screenSize.width *
                      0.38, // Setting the left position of the button
                  child: ElevatedButton(
                    // Creating an ElevatedButton widget for the back button
                    onPressed: () {
                      // Handling button press to navigate back
                      Navigator.pop(
                          context); // Popping the current page from the navigation stack
                    },
                    style: ElevatedButton.styleFrom(
                      // Styling the button
                      backgroundColor: const Color(
                          0xFF011F4B), // Setting button background color
                      shape: const CircleBorder(), // Making button circular
                    ),
                    child: Image.asset(
                      // Adding an image inside the button
                      'lib/images/historyBack.png', // Image file path
                      width: 50, // Setting image width
                      height: 50, // Setting image height
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

  // Widget to build the header row of the translations
  Widget _buildHeaderRow(Size screenSize) {
    final double headerWidth =
        screenSize.width * 0.12; // Calculating the width of the header cells

    return Container(
      // Creating a container for the header row
      decoration: const BoxDecoration(
        // Adding decoration to the container
        border: Border(
          // Adding borders to the container
          bottom: BorderSide(color: Colors.white), // Adding a bottom border
          top: BorderSide(color: Colors.white), // Adding a top border
        ),
      ),
      child: Row(
        // Creating a row to display header cells
        children: [
          SizedBox(
            // Adding a SizedBox for the "Date" header cell
            width: headerWidth * 1.5, // Setting width of the header cell
            height:
                screenSize.height * 0.05, // Setting height of the header cell
            child: const Center(
              // Centering text in the header cell
              child: Text(
                // Adding text to the header cell
                'Date', // Text content for the "Date" header cell
                style: TextStyle(
                  // Styling the text
                  fontFamily: 'Intro Rust', // Setting font family
                  fontSize: 10, // Setting font size
                  color: Colors.white, // Setting text color
                ),
              ),
            ),
          ),
          SizedBox(
            // Adding a SizedBox for the "Question" header cell
            width: headerWidth * 4, // Setting width of the header cell
            child: const Center(
              // Centering text in the header cell
              child: Text(
                // Adding text to the header cell
                'Question', // Text content for the "Question" header cell
                style: TextStyle(
                  // Styling the text
                  fontFamily: 'Intro Rust', // Setting font family
                  fontSize: 10, // Setting font size
                  color: Colors.white, // Setting text color
                ),
              ),
            ),
          ),
          const SizedBox(
            // Adding a SizedBox for the empty header cell
            child: Center(
              // Centering text in the header cell
              child: Text(
                // Adding text to the header cell
                '', // Text content for the empty header cell
                style: TextStyle(
                  // Styling the text
                  fontFamily: 'Intro Rust', // Setting font family
                  fontSize: 10, // Setting font size
                  color: Colors.white, // Setting text color
                ),
              ),
            ),
          ),
          SizedBox(
              width: screenSize.width *
                  0.04), // Adding spacing between header cells
        ],
      ),
    );
  }

  // Widget to build a data row for a translation
  Widget _buildDataRow(
      BuildContext context,
      Size screenSize,
      List<Map<String, dynamic>> translations,
      Map<String, dynamic> translation) {
    final double headerWidth =
        screenSize.width * 0.12; // Calculating the width of the header cells

    return Container(
      // Creating a container for the data row
      decoration: const BoxDecoration(
        // Adding decoration to the container
        border: Border(
          // Adding borders to the container
          bottom: BorderSide(color: Colors.white), // Adding a bottom border
        ),
      ),
      child: Row(
        // Creating a row to display data cells
        children: [
          SizedBox(
            // Adding a SizedBox for the "Date" data cell
            width: headerWidth * 1.5, // Setting width of the data cell
            child: Center(
              // Centering text in the data cell
              child: Padding(
                // Adding padding to the text in the data cell
                padding:
                    const EdgeInsets.all(4.0), // Setting padding for the text
                child: Text(
                  // Adding text to the data cell
                  translation['date'], // Text content for the "Date" data cell
                  style: const TextStyle(
                    // Styling the text
                    fontFamily: 'Intro Rust', // Setting font family
                    fontSize: 10, // Setting font size
                    color: Colors.white, // Setting text color
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            // Adding a SizedBox for the "Question" data cell
            width: headerWidth * 3.8, // Setting width of the data cell
            child: Center(
              // Centering text in the data cell
              child: Padding(
                // Adding padding to the text in the data cell
                padding:
                    const EdgeInsets.all(4.0), // Setting padding for the text
                child: Text(
                  // Adding text to the data cell
                  translation[
                      'question'], // Text content for the "Question" data cell
                  style: const TextStyle(
                    // Styling the text
                    fontFamily: 'Intro Rust', // Setting font family
                    fontSize: 10, // Setting font size
                    color: Colors.white, // Setting text color
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            // Adding a SizedBox for the "View" button data cell
            width: screenSize.width * 0.3, // Setting width of the data cell
            child: ElevatedButton(
              // Creating an ElevatedButton widget for the "View" button
              onPressed: () {
                // Handling button press to view translation details
                Navigator.push(
                  // Navigating to the view history page to view translation details
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewHistoryPage(
                      // Building the view history page with translation details
                      number: translation['id'], // Passing translation ID
                      date: translation['date'], // Passing translation date
                      time: translation['time'], // Passing translation time
                      question: translation[
                          'question'], // Passing translation question
                      response: translation[
                          'response'], // Passing translation response
                      translatedResponse: translation[
                          'translated_response'], // Passing translated response
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                // Styling the button
                backgroundColor:
                    Colors.white, // Setting button background color
                minimumSize: Size(
                    screenSize.width * 0.25, 35), // Setting button minimum size
              ),
              child: const Text(
                // Adding text to the "View" button
                'Tap to View', // Text content for the "View" button
                style: TextStyle(
                  // Styling the text
                  fontFamily: 'Intro Rust', // Setting font family
                  fontSize: 10, // Setting font size
                  color: Color.fromARGB(255, 0, 16, 29), // Setting text color
                ),
              ),
            ),
          ),
          SizedBox(
              width:
                  screenSize.width * 0.04), // Adding spacing between data cells
        ],
      ),
    );
  }
}
