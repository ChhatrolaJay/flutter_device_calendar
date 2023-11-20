package com.jayc.flutter_device_calendar

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.ContentUris
import android.content.ContentValues
import android.net.Uri
import android.provider.CalendarContract
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.text.SimpleDateFormat
import java.util.*

/** FlutterDeviceCalendarPlugin */
class FlutterDeviceCalendarPlugin : FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var defaultCalendarId: Long = 0
  private lateinit var contentResolver: ContentResolver

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_device_calendar")
    channel.setMethodCallHandler(this)
    contentResolver = flutterPluginBinding.applicationContext.contentResolver
  }
  @SuppressLint("Range")
  override fun onMethodCall(call: MethodCall, result: Result) {
//    if (call.method == "getPlatformVersion") {
//      result.success("Android Number ${android.os.Build.VERSION.RELEASE}")
//    } else {
//      result.notImplemented()
//    }

    if (call.method =="addEventsToCalendar") {
      try {
        val events: List<Map<String, Any>>? = call.argument("events")
        if (events != null) {
          /// Taking the existing events from the calendar and look if app package
          // is ims connect delete the event for the particular appointment date
          // so it will not change events of any different day
          // and than we will insert it again.

          // Parse the event date string into a Date object
          val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
          val parsedDate: Date =
            dateFormat.parse(events[0]["scheduleDate"] as String) as Date

          // Convert the parsed date to milliseconds
          val eventStartTimeInMillis = parsedDate.time
          val eventEndTimeInMillis =
            eventStartTimeInMillis + (24 * 60 * 60 * 1000) // Assuming you want events for the entire day

          val projection1 = arrayOf(CalendarContract.Events._ID)
          val selection =
            "${CalendarContract.Events.CUSTOM_APP_PACKAGE} = ? AND ${CalendarContract.Events.DTSTART} >= ? AND ${CalendarContract.Events.DTEND} <= ?"
          // val selection = "${Events.CUSTOM_APP_PACKAGE} = ?"
          // val selectionArgs =arrayOf("IMS Connect")
          val selectionArgs = arrayOf(
            "${events[0]["organizerId"]}",
            eventStartTimeInMillis.toString(),
            eventEndTimeInMillis.toString()
          )

          val cursor1 = contentResolver.query(
            CalendarContract.Events.CONTENT_URI,
            projection1,
            selection,
            selectionArgs,
            null
          )

          cursor1?.use { it ->
            while (it.moveToNext()) {
              val eventId = it.getLong(it.getColumnIndex(CalendarContract.Events._ID))
              // Delete the event
              val deleteUri: Uri =
                ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, eventId)
              contentResolver.delete(deleteUri, null, null)
              println("Deleted Event with ID: $eventId")
            }
          }
          /// Taking each event from appointment list and insert into calendar.
          for (eve in events) {
            val projection = arrayOf(CalendarContract.Calendars._ID)
            val cursor = contentResolver.query(
              CalendarContract.Calendars.CONTENT_URI,
              projection,
              CalendarContract.Calendars.VISIBLE + " = 1",
              null,
              CalendarContract.Calendars._ID + " ASC"
            )
            /// finding the default calendar id and assign to variable.
            if (cursor != null && cursor.moveToFirst()) {
              defaultCalendarId =
                cursor.getLong(cursor.getColumnIndex(CalendarContract.Calendars._ID))
              cursor.close()
            }
            val inputDateString =
              "${eve["scheduleDate"]} ${eve["scheduleTime"]}"
            val startTimeMillis = convertStringToMillis(inputDateString)
            val endTimeMillis =
              startTimeMillis + (eve["duration"] as String).toLong() * 60 * 1000

            /// eventID should be always unique inorder to prevent similar id.
            val eventID: Long = System.currentTimeMillis()
            val values = ContentValues().apply {
              put(CalendarContract.Events.DTSTART, startTimeMillis)
              put(CalendarContract.Events.DTEND, endTimeMillis)
              put(CalendarContract.Events.TITLE, eve["title"] as String)
              put(CalendarContract.Events.CALENDAR_ID, defaultCalendarId)
              put(CalendarContract.Events.EVENT_TIMEZONE, eve["eventTimeZone"] as String/*"Asia/Kolkata"*/)
              put(CalendarContract.Events._ID, eventID)
              eve["color"]?.let { put(CalendarContract.Events.EVENT_COLOR, it as String) }
              eve["location"]?.let { put(CalendarContract.Events.EVENT_LOCATION, it as String) }
              eve["description"]?.let { put(CalendarContract.Events.DESCRIPTION, it as String) }
              eve["organizerId"]?.let { put(CalendarContract.Events.CUSTOM_APP_PACKAGE, it as String) }
            }
            contentResolver.insert(CalendarContract.Events.CONTENT_URI, values)
            //println("Inserted Event with ID: $eventID")
          }
          result.success("Inserted Events")
        }
      } catch (e: Exception) {
        // Handle exceptions here
        println("Error occurred: ${e.message}")
      }
    }
     else {
      result.notImplemented()
    }

  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  @SuppressLint("SimpleDateFormat")
  fun convertStringToMillis(dateTimeString: String): Long {
    val format = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
    val date = format.parse(dateTimeString)
    if (date != null) {
      return date.time
    }
    return 0
  }

}
