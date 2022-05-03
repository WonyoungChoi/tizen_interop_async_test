import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:tizen_native/tizen_native.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _batteryLevel = -1;
  int _testValue = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  static void _batteryChanged(
      int type, Pointer<Void> value, Pointer<Void> userData) {
    print('batteryChanged');
  }

  Future<void> initPlatformState() async {
    final int batteryLevel = using((Arena arena) {
      Pointer<Int32> pResult = arena();
      if (tizen.device_battery_get_percent(pResult) == 0) {
        return pResult.value;
      }
      return -1;
    });

    final int testValue = tizen.ffi_test_function(10, 20);

    Pointer<NativeFunction<device_changed_cb>> _batteryChangedCallback =
        Pointer.fromFunction<device_changed_cb>(_batteryChanged);
    int ret = tizen.device_add_callback(2 /*DEVICE_CALLBACK_BATTERY_CHARGING */,
        _batteryChangedCallback, nullptr);
    if (ret != 0) {
      throw Exception('Failed to add callback');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _batteryLevel = batteryLevel;
      _testValue = testValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Row(
          children: [
            Text('Battery level: $_batteryLevel%'),
            Text('Test value: $_testValue'),
          ],
        ),
      ),
    );
  }
}
