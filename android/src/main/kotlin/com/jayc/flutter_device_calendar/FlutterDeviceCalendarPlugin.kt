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

class FlutterDeviceCalendarPlugin : FlutterPlugin, MethodCallHandler {

  private lateinit var channel: MethodChannel
  private lateinit var contentResolver: ContentResolver

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_device_calendar")
    channel.setMethodCallHandler(this)
    contentResolver = flutterPluginBinding.applicationContext.contentResolver
  }

  @SuppressLint("Range")
  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "addEventsToCalendar" -> handleAddEventsToCalendar(call, result)
      else -> result.notImplemented()
    }
  }

  private fun handleAddEventsToCalendar(call: MethodCall, result: Result) {
    try {
      val events: List<Map<String, Any>>? = call.argument("events")
      if (events != null) {
        handleDeleteExistingEvents(events)

        for (eve in events) {
          val defaultCalendarId = findDefaultCalendarId()

          val startTimeMillis = convertStringToMillis("${eve["scheduleDate"]} ${eve["scheduleTime"]}")
          val endTimeMillis = startTimeMillis + (eve["duration"] as String).toLong() * 60 * 1000

          val eventID: Long = System.currentTimeMillis()
          val values = createEventContentValues(eve, startTimeMillis, endTimeMillis, defaultCalendarId, eventID)

          contentResolver.insert(CalendarContract.Events.CONTENT_URI, values)
          println("Inserted Event with ID: $eventID")
        }

        result.success("Inserted Events")
      }
    } catch (e: Exception) {
      println("Error occurred: ${e.message}")
      result.error("",e.message,"")
    }
  }

  @SuppressLint("Range")
  private fun handleDeleteExistingEvents(events: List<Map<String, Any>>) {
    val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
    for (eve in events) {
      val parsedDate: Date = dateFormat.parse(eve["scheduleDate"] as String) as Date
      val eventStartTimeInMillis = parsedDate.time
      val eventEndTimeInMillis = eventStartTimeInMillis + (24 * 60 * 60 * 1000)

      val selection =
        "${CalendarContract.Events.CUSTOM_APP_PACKAGE} = ? AND ${CalendarContract.Events.DTSTART} >= ? AND ${CalendarContract.Events.DTEND} <= ?"

      val selectionArgs = arrayOf(
        "${eve["organizerId"]}",
        eventStartTimeInMillis.toString(),
        eventEndTimeInMillis.toString()
      )

      val projection = arrayOf(CalendarContract.Events._ID)
      val cursor = contentResolver.query(
        CalendarContract.Events.CONTENT_URI,
        projection,
        selection,
        selectionArgs,
        null
      )

      cursor?.use {
        while (it.moveToNext()) {
          val eventId = it.getLong(it.getColumnIndex(CalendarContract.Events._ID))
          val deleteUri: Uri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, eventId)
          contentResolver.delete(deleteUri, null, null)
          println("Deleted Event with ID: $eventId")
        }
      }
    }
  }

  @SuppressLint("Range")
  private fun findDefaultCalendarId(): Long {
    val projection = arrayOf(CalendarContract.Calendars._ID)
    val cursor = contentResolver.query(
      CalendarContract.Calendars.CONTENT_URI,
      projection,
      "${CalendarContract.Calendars.VISIBLE} = 1",
      null,
      "${CalendarContract.Calendars._ID} ASC"
    )

    return cursor?.use {
      if (it.moveToFirst()) {
        it.getLong(it.getColumnIndex(CalendarContract.Calendars._ID))
      } else {
        0
      }
    } ?: 0
  }

  @SuppressLint("SimpleDateFormat")
  private fun convertStringToMillis(dateTimeString: String): Long {
    val format = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
    val date = format.parse(dateTimeString)
    return date?.time ?: 0
  }

  private fun createEventContentValues(
    eve: Map<String, Any>,
    startTimeMillis: Long,
    endTimeMillis: Long,
    defaultCalendarId: Long,
    eventID: Long
  ): ContentValues {
    return ContentValues().apply {
      put(CalendarContract.Events.DTSTART, startTimeMillis)
      put(CalendarContract.Events.DTEND, endTimeMillis)
      put(CalendarContract.Events.TITLE, eve["title"] as String)
      put(CalendarContract.Events.CALENDAR_ID, defaultCalendarId)
      put(CalendarContract.Events.EVENT_TIMEZONE, eve["eventTimeZone"] as String)
      put(CalendarContract.Events._ID, eventID)
      eve["color"]?.let { put(CalendarContract.Events.EVENT_COLOR, it as String) }
      eve["location"]?.let { put(CalendarContract.Events.EVENT_LOCATION, it as String) }
      eve["description"]?.let { put(CalendarContract.Events.DESCRIPTION, it as String) }
      eve["organizerId"]?.let { put(CalendarContract.Events.CUSTOM_APP_PACKAGE, it as String) }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
