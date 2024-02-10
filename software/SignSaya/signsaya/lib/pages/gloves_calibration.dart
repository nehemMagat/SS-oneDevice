import 'package:flutter/material.dart';

class GlovesCalibration extends StatefulWidget {
  const GlovesCalibration({Key? key}) : super(key: key);

  @override
  _GlovesCalibrationState createState() => _GlovesCalibrationState();
}

class _GlovesCalibrationState extends State<GlovesCalibration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'lib/images/backgroundTranslation.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 650,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'FINISH',
                    style: TextStyle(
                      fontFamily: 'Intro Rust',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
              child: Center(
            child: Text(
              "CALIBRATION THINGY HERE/ PALITAN NALANG BG IF DI KAILANGAN",
              style: TextStyle(color: Colors.white),
            ),
          ))
        ],
      ),
    );
  }
}
