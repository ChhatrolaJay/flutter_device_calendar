import 'flutter_device_calendar_platform_interface.dart';

class FlutterDeviceCalendar {
  Future<void> addEvents({required List<Event> eventsList}) async {
    return FlutterDeviceCalendarPlatform.instance
        .addEvents(eventsList: eventsList);
  }
}

class Event {
  final String title;
  final String scheduleTime;
  final String scheduleDate;
  final String duration;
  final String? description;
  final String eventTimeZone;
  final String? location;
  final String? organizerId;
  final String? color;

  Event(
      {required this.title,
      required this.scheduleTime,
      required this.scheduleDate,
      required this.duration,
      required this.eventTimeZone,
      this.description,
      this.location,
      this.organizerId,
      this.color});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['scheduleTime'] = scheduleTime;
    data['scheduleDate'] = scheduleDate;
    data['duration'] = duration;
    data['description'] = description;
    data['eventTimeZone'] = eventTimeZone;
    data['location'] = location;
    data['organizerId'] = organizerId;
    data['color'] = color;

    return data;
  }
}
