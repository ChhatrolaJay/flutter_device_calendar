import 'package:flutter_device_calendar/event_dm.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_device_calendar_method_channel.dart';

abstract class FlutterDeviceCalendarPlatform extends PlatformInterface {
  /// Constructs a FlutterDeviceCalendarPlatform.
  FlutterDeviceCalendarPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDeviceCalendarPlatform _instance = MethodChannelFlutterDeviceCalendar();

  /// The default instance of [FlutterDeviceCalendarPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterDeviceCalendar].
  static FlutterDeviceCalendarPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterDeviceCalendarPlatform] when
  /// they register themselves.
  static set instance(FlutterDeviceCalendarPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> addEvents({required List<Event> eventsList}) async {
    throw UnimplementedError('No events method found');
  }

}
