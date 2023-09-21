import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';

import 'package:kalender/src/models/tile_configurations/month_tile_configuration.dart';
import 'package:kalender/src/models/tile_configurations/multi_day_tile_configuration.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration.dart';
import 'package:kalender/src/models/tile_layout_controllers/day_tile_layout_controller/day_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller/month_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/multi_day_layout_controller.dart';

/// The [CalendarHeaderBuilder] is used to build the header displayed in the calendar's header.
typedef CalendarHeaderBuilder<T extends Object?> = Widget Function(
  DateTimeRange visibleDateTimeRange,
);

/// The [DayHeaderBuilder] is used to build the header displayed above a day.
typedef DayHeaderBuilder<T extends Object?> = Widget Function(
  DateTime date,
  void Function(DateTime date)? onTapped,
);

/// TODO: remove explicit sizes where possible. ///

/// The [HourLinesBuilder] is used to build the hourlines displayed on calendar's.
typedef HourLinesBuilder<T extends Object?> = Widget Function(
  double hourHeight,
);

/// The [DaySeparatorBuilder] is used to build the seperators between days.
typedef DaySeparatorBuilder<T extends Object?> = Widget Function(
  int numberOfDays,
);

/// The [TimelineBuilder] is used to build the timeline displayed on the left side of the calendar.
typedef TimelineBuilder<T extends Object?> = Widget Function(
  double hourHeight,
);

/// The [WeekNumberBuilder] is used to build the week number displayed on the left side of the calendar.
typedef WeekNumberBuilder<T extends Object?> = Widget Function(
  DateTimeRange visibleDateRange,
);

/// The [TimeIndicatorBuilder] is used to build the time indicator displayed on current day.
typedef TimeIndicatorBuilder = Widget Function(
  List<DateTime> visibleDates,
  double heightPerMinute,
  double dayWidth,
);

/// The [MonthGridBuilder] is used to build the month grid displayed on the calendar.
typedef MonthGridBuilder = Widget Function(
  double pageHeight,
  double cellHeight,
  double cellWidth,
);

/// The [MonthCellHeaderBuilder] is used to build the header displayed above a day.
typedef MonthCellHeaderBuilder = Widget Function(
  DateTime date,
  void Function(DateTime date)? onTapped,
);

/// The [MonthHeaderBuilder] is used to build the header displayed above the month grid.
typedef MonthHeaderBuilder = Widget Function(
  double dayWidth,
  DateTime date,
);

/// The [TileBuilder]
///
/// The [drawOutline] parameter is used to indicate whether the event should be drawn with an outline.
/// This is true when the event is displayed on top of another event.
///
/// This builder is used to build event tiles that are displayed on [PageType.singleDay] and [PageType.multiDay] days.
/// The [continuesBefore] and [continuesAfter] parameters are used to indicate whether the event
/// continues before or after the day they are displayed on.
typedef TileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  TileConfiguration configuration,
);

/// The [TileHandleBuilder]
///
/// This builder is used to build the handle displayed on the event tiles. (Mobile only)
typedef TileHandleBuilder = Widget Function();

/// The [MultiDayTileBuilder]
///
/// This builder is used to build event tiles that are displayed on multiple days.
/// The [continuesBefore] and [continuesAfter] parameters are used to indicate whether the event
/// continues before or after the visible date range.
typedef MultiDayTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  MultiDayTileConfiguration configuration,
);

/// The [MonthTileBuilder]
///
/// This builder is used to build event tiles that are displayed on a specific date.
typedef MonthTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  MonthTileConfiguration configuration,
);

/// The [ScheduleEventTileBuilder]
///
/// This builder is used to build event tiles that are displayed on a specific date.
typedef ScheduleEventTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  DateTime date,
);

/// The [DayLayoutController] is used to calculate the layout of the tiles displayed on a day.
///
/// The typedef is used to create a function that returns a [DayTileLayoutControllerOLD].
typedef DayLayoutController<T extends Object?> = DayTileLayoutControllerOLD<T>
    Function({
  required DateTimeRange visibleDateRange,
  required List<DateTime> visibleDates,
  required double heightPerMinute,
  required double dayWidth,
});

/// The [MultiDayLayoutController] is used to calculate the layout of the tiles displayed on a day.
///
/// The typedef is used to create a function that returns a [MultiDayTileLayoutController].
typedef MultiDayLayoutController<T extends Object?>
    = MultiDayTileLayoutController<T> Function({
  required DateTimeRange visibleDateRange,
  required double dayWidth,
  required double tileHeight,
});

/// The [MonthLayoutController] is used to calculate the layout of the tiles displayed on a day.
///
/// The typedef is used to create a function that returns a [MonthTileLayoutController].
typedef MonthLayoutController<T extends Object?> = MonthTileLayoutController<T>
    Function({
  required DateTimeRange visibleDateRange,
  required double cellWidth,
  required double tileHeight,
});

/// The [MultiDayTilesLayoutAlgorithm] is used to calculate the layout of the tiles displayed on a multiday view.
typedef MultiDayTilesLayoutAlgorithm<T extends Object> = MultiDayLayoutData<T>
    Function({
  required Iterable<CalendarEvent<dynamic>> events,
  required double tileHeight,
  required double dayWidth,
  required DateTimeRange visibleDateRange,
});
