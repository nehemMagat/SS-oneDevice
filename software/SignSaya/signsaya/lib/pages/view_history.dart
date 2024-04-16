import 'package:flutter/material.dart';
import 'package:SignSaya/pages/signsaya_database_config.dart';

class ViewHistoryPage extends StatelessWidget {
  final int number;
  final String date;
  final String time;
  final String question;
  final String response;
  final String translatedResponse;

  const ViewHistoryPage({
    Key? key,
    required this.number,
    required this.date,
    required this.time,
    required this.question,
    required this.response,
    required this.translatedResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Image.asset(
          'lib/images/backgroundTranslation.png',
          fit: BoxFit.cover,
          width: screenSize.width,
          height: screenSize.height,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildMessage(
                              'You', question, time, Colors.blue, Icons.person),
                          _buildTranslatedResponse(
                              'Receiver',
                              translatedResponse,
                              response,
                              time,
                              Colors.black,
                              Icons.account_circle),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showDeleteConfirmation(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF011F4B),
                            shape: const CircleBorder(),
                          ),
                          child: Image.asset(
                            'lib/images/delBttn.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
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
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: screenSize.height * 0.23,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        date,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Confirmation"),
        content: Text("Are you sure you want to delete this conversation?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              print("Delete conversation pressed");
              await _deleteConversation(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteConversation(BuildContext context) async {
    try {
      print("Deleting conversation with number: $number");
      final db = SignSayaDatabase();
      final result = await db.deleteTranslation(number);
      print("Delete result: $result");
      _showDeleteSuccessDialog(context, number);
    } catch (e) {
      print("Error deleting conversation: $e");
      _showDeleteErrorDialog(context);
    }
  }

  void _showDeleteSuccessDialog(BuildContext context, int deletedNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Conversation Deleted"),
        content: Text("The conversation has been deleted."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Pop the dialog
              Navigator.pop(context); // Pop the ViewHistoryPage
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showDeleteErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error Deleting Conversation"),
        content: Text("An error occurred while deleting the conversation."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String sender, String message, String? subtext,
      Color color, IconData iconData) {
    return Align(
      alignment: sender == 'You' ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: sender == 'You' ? 20 : 16,
              right: sender == 'You' ? 16 : 20,
              top: 8,
              bottom: 8,
            ),
            margin: EdgeInsets.only(
              bottom: 8,
              right: sender == 'You' ? 60 : 0,
              left: sender == 'You' ? 0 : 60,
              top: sender == 'You' ? 255 : 0,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(24),
                topRight: const Radius.circular(24),
                bottomLeft: sender == 'You'
                    ? const Radius.circular(24)
                    : const Radius.circular(0),
                bottomRight: sender == 'You'
                    ? const Radius.circular(0)
                    : const Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                if (subtext != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtext,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: sender == 'You' ? 0 : 16,
            child: CircleAvatar(
              backgroundColor: sender == 'You' ? Colors.blue : Colors.black,
              radius: 25,
              child: Icon(
                iconData,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslatedResponse(String receiver, String translatedResponse,
      String response, String time, Color color, IconData iconData) {
    return Align(
      alignment:
          receiver == 'Receiver' ? Alignment.centerLeft : Alignment.centerRight,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: receiver == 'Receiver' ? 16 : 20,
              right: receiver == 'Receiver' ? 20 : 16,
              top: 8,
              bottom: 8,
            ),
            margin: EdgeInsets.only(
              right: receiver == 'Receiver' ? 0 : 60,
              left: receiver == 'Receiver' ? 60 : 0,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(24),
                topRight: const Radius.circular(24),
                bottomRight: receiver == 'Receiver'
                    ? const Radius.circular(24)
                    : const Radius.circular(0),
                bottomLeft: receiver == 'Receiver'
                    ? const Radius.circular(0)
                    : const Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  translatedResponse,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: receiver == 'Receiver' ? 0 : 16,
            child: CircleAvatar(
              backgroundColor:
                  receiver == 'Receiver' ? Colors.black : Colors.black,
              radius: 25,
              child: Icon(
                iconData,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
