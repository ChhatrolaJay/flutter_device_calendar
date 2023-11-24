import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_device_calendar/flutter_device_calendar.dart';
import 'package:flutter_device_calendar/event_dm.dart'; // Import your Event class

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
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _flutterDeviceCalendarPlugin = FlutterDeviceCalendar();
  }

  /// This is the sample event list which will be added to the device calendar.
  List<Event> eventList = [
    // Example 1: Adding an event with detailed information
    Event(
      title: "Sample Appointment 1",
      scheduleTime: "10:00:00",
      scheduleDate: "2023-11-24",
      duration: "30",
      location: "Office 1",
      color: "0xFFFF0000",
      organizerId: 'DeviceCalendar',
      eventTimeZone: "Asia/Kolkata",
      description: "This is a sample description",
    ),
    // Example 2: Adding a simple event with minimum required information
    Event(
      title: "Sample Appointment 2",
      scheduleTime: "12:00:00",
      scheduleDate: "2023-11-24",
      eventTimeZone: "Asia/Kolkata",
      duration: "60",
      organizerId: 'DeviceCalendar',
      location: "Office 2",
      description: "This is a sample description",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Device Calendar'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: eventList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 100,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF5F0F8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(-7, 7),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Displaying event title
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 12.0),
                              child: Text(
                                eventList[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            // Displaying event description (if available)
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                eventList[index].description ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
                              ),
                            ),
                            const Spacer(),
                            // Displaying event details in a row
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  CustomContainer(
                                      text: eventList[index].scheduleDate),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 6.0),
                                    child: VerticalDivider(),
                                  ),
                                  CustomContainer(
                                      text: eventList[index].scheduleTime),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 6.0),
                                    child: VerticalDivider(),
                                  ),
                                  CustomContainer(
                                      text: eventList[index].location ?? ""),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            // Button to add appointments to the device calendar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                child: const Text('Add appointments to device calendar'),
                onPressed: () async {
                  if (Platform.isAndroid) {
                    // Trigger the plugin to add events to the device calendar
                    try {
                      await _flutterDeviceCalendarPlugin.addEvents(
                        eventsList: eventList,
                      );
                      if (!mounted) return;
                      _messangerKey.currentState?.showSnackBar(const SnackBar(
                          content: Text('Events added successfully')));
                    } catch (e) {
                      debugPrint('Found some error :${e.toString()}');
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}

// Custom widget to display text in an expanded container
class CustomContainer extends StatelessWidget {
  const CustomContainer({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: Center(child: Text(text)),
      ),
    );
  }
}
