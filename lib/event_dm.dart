/// Represents an event that can be scheduled in the device calendar.
///
/// This class accepts a list of [Event] instances with the following parameters:
/// - title : Heading of the event.
/// - scheduleTime : Time of the specific event in 24hrs format (e.g., "15:30:00" for 3:30:00 PM).
/// - scheduleDate : Particular date of the specific event in format "yyyy-MM-dd".
/// - duration : How much time (in minutes) the event is scheduled for; no need to give end time.
/// - description : Notes or short description related to the event (optional).
/// - eventTimeZone : Time zone in which the event will be scheduled.
/// - location : Where the event is scheduled (optional).
/// - organizerId : A unique application name used to differentiate from other events in the device calendar (optional).
/// - color : Color code in hexadecimal("0xFFFF0000") to define the color of the event (optional).
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

  /// Constructor for the [Event] class.
  ///
  /// Parameters:
  /// - `title`: Heading of the event.
  /// - `scheduleTime`: Time of the specific event in 24hrs format (e.g., "15:30:00" for 3:30:00 PM).
  /// - `scheduleDate`: Particular date of the specific event in format "yyyy-MM-dd".
  /// - `duration`: How much time (in minutes) the event is scheduled for; no need to give end time.
  /// - `eventTimeZone`: Time zone in which the event will be scheduled.
  /// - `description`: Notes or short description related to the event (optional).
  /// - `location`: Where the event is scheduled (optional).
  /// - `organizerId`: A unique application name used to differentiate from other events in the device calendar (optional).
  /// - `color`: Color code in hexadecimal("0xFFFF0000") to define the color of the event (optional).
  Event({
    required this.title,
    required this.scheduleTime,
    required this.scheduleDate,
    required this.duration,
    required this.eventTimeZone,
    this.description,
    this.location,
    this.organizerId,
    this.color,
  });

  /// Converts the [Event] instance to a JSON representation.
  ///
  /// Returns a [Map] containing key-value pairs representing the event properties.
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
