import 'dart:ffi';
import 'dart:isolate';

typedef _c_device_battery_get_percent = Int32 Function(Pointer<Int32> percent);
typedef _dart_device_battery_get_percent = int Function(Pointer<Int32> percent);

typedef _c_ffi_test_function = Int32 Function(Int32 a, Int32 b);
typedef _dart_ffi_test_function = int Function(int a, int b);

typedef device_changed_cb = Void Function(
  Int32,
  Pointer<Void>,
  Pointer<Void>,
);

typedef _c_device_add_callback = Int32 Function(
  Int32 type,
  Pointer<NativeFunction<device_changed_cb>> callback,
  Pointer<Void> user_data,
);

typedef _dart_device_add_callback = int Function(
  int type,
  Pointer<NativeFunction<device_changed_cb>> callback,
  Pointer<Void> user_data,
);

class TizenBindings {
  TizenBindings() {
    _devicelib = DynamicLibrary.open('libcapi-system-device.so.0');
    _pluginLib = DynamicLibrary.open('libflutter_plugins.so');

    device_battery_get_percent = _devicelib.lookupFunction<
        _c_device_battery_get_percent, _dart_device_battery_get_percent>(
      'device_battery_get_percent',
    );

    ffi_test_function = _pluginLib
        .lookupFunction<_c_ffi_test_function, _dart_ffi_test_function>(
      'ffi_test_function',
    );

    device_add_callback = _devicelib
        .lookupFunction<_c_device_add_callback, _dart_device_add_callback>(
      'device_add_callback',
    );
  }

  late DynamicLibrary _devicelib;
  late DynamicLibrary _pluginLib;

  late _dart_device_battery_get_percent device_battery_get_percent;
  late _dart_ffi_test_function ffi_test_function;
  late _dart_device_add_callback device_add_callback;
}
