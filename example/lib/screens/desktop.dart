import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_header.dart';
import 'package:example/widgets/event_tile.dart';
import 'package:example/widgets/multi_day_event_tile.dart';
import 'package:example/widgets/schedule_event_tile.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({
    super.key,
    required this.eventsController,
  });
  final CalendarEventsController<Event> eventsController;

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  final CalendarController<Event> calendarController =
      CalendarController<Event>();
  late ViewConfiguration currentConfiguration = viewConfigurations[1];
  late List<ViewConfiguration> viewConfigurations = [
    const CustomMultiDayConfiguration(
      name: 'Day',
      numberOfDays: 1,
    ),
    const CustomMultiDayConfiguration(
      name: '2 Days',
      numberOfDays: 2,
    ),
    const WeekConfiguration(),
    const WorkWeekConfiguration(),
    const MonthConfiguration(),
  ];

  @override
  Widget build(BuildContext context) {
    return CalendarView<Event>(
      controller: calendarController,
      eventsController: widget.eventsController,
      viewConfiguration: currentConfiguration,
      tileBuilder: _tileBuilder,
      multiDayTileBuilder: _multiDayTileBuilder,
      scheduleTileBuilder: _scheduleTileBuilder,
      components: CalendarComponents(
        calendarHeaderBuilder: _calendarHeaderBuilder,
      ),
      eventHandlers: CalendarEventHandlers<Event>(
        onEventChanged: onEventChanged,
        onEventTapped: onEventTapped,
        onCreateEvent: onCreateEvent,
        onDateTapped: onDateTapped,
      ),
    );
  }

  /// This function is called when a new event is created.
  Future<void> onCreateEvent(newEvent) async {}

  /// This function is called when an event is tapped.
  Future<void> onEventTapped(event) async {}

  /// This function is called when an event is changed.
  Future<void> onEventChanged(
    DateTimeRange initialDateTimeRange,
    CalendarEvent<Event> event,
  ) async {}

  /// This function is called when a date is tapped.
  void onDateTapped(date) {
    // If the current view is not the single day view, change the view to the single day view.
    if (currentConfiguration is! DayConfiguration) {
      setState(() {
        // Set the selected date to the tapped date.

        currentConfiguration = viewConfigurations.first;
      });
    }
  }

  Widget _calendarHeaderBuilder(DateTimeRange visibleDateTimeRange) {
    return CalendarHeader(
      calendarController: calendarController,
      viewConfigurations: viewConfigurations,
      currentConfiguration: currentConfiguration,
      onViewConfigurationChanged: (viewConfiguration) {
        setState(() {
          currentConfiguration = viewConfiguration;
        });
      },
      visibleDateTimeRange: visibleDateTimeRange,
    );
  }

  Widget _tileBuilder(
    CalendarEvent<Event> event,
    TileConfiguration tileConfiguration,
  ) {
    return EventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      drawOutline: tileConfiguration.drawOutline,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<Event> event,
    MultiDayTileConfiguration tileConfiguration,
  ) {
    return MultiDayEventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }

  Widget _scheduleTileBuilder(
    CalendarEvent<Event> event,
    DateTime date,
  ) {
    return ScheduleTile(
      event: event,
      date: date,
    );
  }
}
