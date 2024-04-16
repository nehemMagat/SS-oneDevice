import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('View History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number: $number',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Date: $date',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Time: $time',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Question: $question',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Response: $response',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Translated Response: $translatedResponse',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
