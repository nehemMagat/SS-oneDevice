import 'package:flutter/material.dart';
import 'package:SignSaya/pages/FBP_screens/widgets/characteristic_tile.dart';

class GlovesCalibration extends StatefulWidget {
  @override
  _GlovesCalibrationState createState() => _GlovesCalibrationState();
}

class _GlovesCalibrationState extends State<GlovesCalibration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gloves Calibration'),
      ),
      body: StreamBuilder<List<int>>(
        stream: CharacteristicTile.sensorValuesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Use the latest sensor values to display in the UI
            List<int> sensorValues = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sensor Values: $sensorValues'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement start recording logic
                      print('Start Recording');
                    },
                    child: Text('Start Recording'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Implement stop recording logic
                      print('Stop Recording');
                    },
                    child: Text('Stop Recording'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: Text('Waiting for sensor values...'),
            );
          }
        },
      ),
    );
  }
}
