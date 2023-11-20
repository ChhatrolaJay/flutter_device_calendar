import 'package:flutter/material.dart';
import 'package:flutter_device_calendar/flutter_device_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FlutterDeviceCalendar _flutterDeviceCalendarPlugin;

  @override
  void initState() {
    super.initState();
    _flutterDeviceCalendarPlugin = FlutterDeviceCalendar();
  }

  /// This is the sample event list which will be added to the device calendar.
  List<Event> eventList = [
    Event(
        title: "Appointment By Plugin",
        scheduleTime: "10:00:00",
        scheduleDate: "2023-11-17",
        duration: "30",
        location: "Office 1",
        color: "0xFFFF0000",
        organizerId: 'DeviceCalendar',
        eventTimeZone: "Asia/Kolkata",
        description: "Description 1"),
    Event(
      title: "Appointment By Plugin 2",
      scheduleTime: "12:00:00",
      scheduleDate: "2023-11-17",
      eventTimeZone: "Asia/Kolkata",
      duration: "60",
      organizerId: 'DeviceCalendar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add to device plugin'),
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text('Add to device calendar'),
            onPressed: () async {
              await _flutterDeviceCalendarPlugin.addEvents(
                  eventsList: eventList);
            },
          ),
        ),
      ),
    );
  }
}
