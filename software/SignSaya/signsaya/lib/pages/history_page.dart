import 'package:flutter/material.dart';
import 'package:SignSaya/pages/signsaya_database_config.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: SignSayaDatabase().getAllTranslations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final translations = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                columns: const [
                  DataColumn(label: Text('Number')),
                  DataColumn(
                    label: Text('Date'),
                    tooltip: 'Date',
                  ),
                  DataColumn(
                    label: Text('Time'),
                    tooltip: 'Time',
                  ),
                  DataColumn(
                    label: Text('Question'),
                    tooltip: 'Question',
                  ),
                  DataColumn(
                    label: Text('Response'),
                    tooltip: 'Response',
                  ),
                  DataColumn(
                    label: Text('Translated Response'),
                    tooltip: 'Translated Response',
                  ),
                  DataColumn(label: Text('')),
                ],
                rows: List<DataRow>.generate(
                  translations.length,
                  (index) {
                    final translation = translations[index];
                    return DataRow(cells: [
                      DataCell(
                        Text((index + 1).toString()),
                      ),
                      DataCell(
                        Text(translation['date']),
                      ),
                      DataCell(
                        Text(translation['time']),
                      ),
                      DataCell(
                        Text(translation['question']),
                      ),
                      DataCell(
                        Text(translation['response']),
                      ),
                      DataCell(
                        Text(translation['translated_response']),
                      ),
                      DataCell(SizedBox()), // Empty cell, lalagyan ko sana ng delete button
                    ]);
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
