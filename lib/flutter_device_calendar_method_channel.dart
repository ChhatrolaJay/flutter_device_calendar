import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_calendar/event_dm.dart';

import 'flutter_device_calendar_platform_interface.dart';

/// An implementation of [FlutterDeviceCalendarPlatform] that uses method channels.
class MethodChannelFlutterDeviceCalendar extends FlutterDeviceCalendarPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_device_calendar');

  @override
  Future<void> addEvents({required List<Event> eventsList}) async {
    List<Map<String, dynamic>> modelListMap =
        eventsList.map((event) => event.toJson()).toList();
    await methodChannel
        .invokeMethod('addEventsToCalendar', {'events': modelListMap});
  }
}
