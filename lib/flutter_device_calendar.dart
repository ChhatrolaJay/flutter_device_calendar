import 'package:flutter_device_calendar/event_dm.dart';
import 'flutter_device_calendar_platform_interface.dart';

class FlutterDeviceCalendar {
  Future<void> addEvents({required List<Event> eventsList}) async {
    return FlutterDeviceCalendarPlatform.instance
        .addEvents(eventsList: eventsList);
  }
}


