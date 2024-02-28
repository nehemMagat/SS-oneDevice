import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

@pragma('vm:entry-point')

void begin() async {
  // first, check if bluetooth is supported by your hardware
// Note: The platform is initialized on the first call to any FlutterBluePlus method.
if (await FlutterBluePlus.isSupported == false) {
    print("Bluetooth not supported by this device");
    return;
}

// handle bluetooth on & off
// note: for iOS the initial state is typically BluetoothAdapterState.unknown
// note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
var subscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
    print(state);
    if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
    } else {
        // show an error to the user, etc
    }
});

// turn on bluetooth ourself if we can
// for iOS, the user controls bluetooth enable/disable
if (Platform.isAndroid) {
    await FlutterBluePlus.turnOn();
}

// cancel to prevent duplicate listeners
subscription.cancel();
}

void scan() async {
  // listen to scan results
// Note: `onScanResults` only returns live scan results, i.e. during scanning
// Use: `scanResults` if you want live scan results *or* the results from a previous scan
var subscription = FlutterBluePlus.onScanResults.listen((results) {
        if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
            connectDevice(r.device);
        }
    },
    onError: (e) => print(e),
);

// cleanup: cancel subscription when scanning stops
FlutterBluePlus.cancelWhenScanComplete(subscription);

// Wait for Bluetooth enabled & permission granted
// In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

// Start scanning w/ timeout
// Optional: you can use `stopScan()` as an alternative to using a timeout
// Note: scan filters use an *or* behavior. i.e. if you set `withServices` & `withNames`
//   we return all the advertisments that match any of the specified services *or* any
//   of the specified names.
await FlutterBluePlus.startScan(
  withKeywords:["SignSaya"],
  timeout: Duration(seconds:15),androidUsesFineLocation: true);

// wait for scanning to stop
await FlutterBluePlus.isScanning.where((val) => val == false).first;


}

void connectDevice (device) async {
  // listen for disconnection
var subscription = device.connectionState.listen((BluetoothConnectionState state) async {
    if (state == BluetoothConnectionState.disconnected) {
        // 1. typically, start a periodic timer that tries to 
        //    reconnect, or just call connect() again right now
        // 2. you must always re-discover services after disconnection!
        print("${device.disconnectReasonCode} ${device.disconnectReasonDescription}");
    }
});
  
// cleanup: cancel subscription when disconnected
// Note: `delayed:true` lets us receive the `disconnected` event in our handler
// Note: `next:true` means cancel on *next* disconnection. Without this, it
//   would cancel immediately because we're already disconnected right now.
device.cancelWhenDisconnected(subscription, delayed:true, next:true);

// Connect to the device
await device.connect();

// Disconnect from device
// await device.disconnect();

// cancel to prevent duplicate listeners
subscription.cancel();
}