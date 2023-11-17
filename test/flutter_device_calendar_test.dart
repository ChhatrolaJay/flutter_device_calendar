import 'package:flutter_device_calendar/flutter_device_calendar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_device_calendar/flutter_device_calendar_platform_interface.dart';
import 'package:flutter_device_calendar/flutter_device_calendar_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterDeviceCalendarPlatform
    with MockPlatformInterfaceMixin
    implements FlutterDeviceCalendarPlatform {
  @override
  Future<void> addEvents({required List<Event> eventsList}) {
    throw UnimplementedError();
  }
}

void main() {
  final FlutterDeviceCalendarPlatform initialPlatform =
      FlutterDeviceCalendarPlatform.instance;

  test('$MethodChannelFlutterDeviceCalendar is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterDeviceCalendar>());
  });
}
