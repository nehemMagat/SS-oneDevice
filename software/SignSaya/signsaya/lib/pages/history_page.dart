import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Date'),
              ),
              DataColumn(
                label: Text('Time'),
              ),
              DataColumn(
                label: Text('Question'),
              ),
              DataColumn(
                label: Text('Response'),
              ),
              DataColumn(
                label: Text('Delete'),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Sample 1')),
                  DataCell(Text('Sample 2')),
                  DataCell(Text('Sample 3')),
                  DataCell(Text('Sample 4')),
                  DataCell(Text('Sample 5')),
                ],
              ),
              // Add more DataRow widgets for additional rows
            ],
          ),
        
      ),
      ),
    );
  }
}

