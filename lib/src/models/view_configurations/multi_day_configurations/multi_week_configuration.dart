import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class MultiWeekConfiguration extends MultiDayViewConfiguration {
  MultiWeekConfiguration({
    this.name = 'Multi Week',
    int numberOfWeeks = 2,
    super.timelineWidth = 56,
    super.daySeparatorLeftOffset = 8,
    super.hourLineLeftMargin = 56,
    super.multiDayTileHeight = 24,
    super.paintWeekNumber = true,
    super.eventSnapping = false,
    super.timeIndicatorSnapping = false,
    super.createEvents = true,
    super.createMultiDayEvents = true,
    super.verticalStepDuration = const Duration(minutes: 15),
    super.verticalSnapRange = const Duration(minutes: 15),
    super.horizontalStepDuration = const Duration(days: 1),
    super.newEventDuration = const Duration(minutes: 15),
    super.enableRescheduling = true,
    super.enableResizing = true,
    super.startHour = 0,
    super.endHour = 24,
    super.initialHeightPerMinute,
    super.createEventTrigger,
    super.showHeader,
  }) {
    _numberOfWeeks = numberOfWeeks;
    super.numberOfDays = numberOfWeeks * 7;
  }

  @override
  final String name;

  late int _numberOfWeeks;
  int get numberOfWeeks => _numberOfWeeks;
  set numberOfWeeks(int value) {
    _numberOfWeeks = value;
    super.numberOfDays = value * 7;
  }

  @override
  DateTimeRange calculateVisibleDateTimeRange(DateTime date) {
    final start = date.startOfWeekWithOffset(firstDayOfWeek);
    final end = start.add(Duration(days: numberOfDays));

    final dateTimeRange = DateTimeRange(
      start: start,
      end: end,
    );

    return dateTimeRange;
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
  }) {
    final normalizedDateTimeRange = DateTimeRange(
      start: dateTimeRange.start.startOfWeekWithOffset(firstDayOfWeek),
      end: dateTimeRange.end.endOfWeekWithOffset(firstDayOfWeek),
    );

    final numberOfFullPages =
        (normalizedDateTimeRange.duration.inDays / numberOfDays).ceil();

    final start = normalizedDateTimeRange.start;
    final end = start.add(Duration(days: numberOfFullPages * numberOfDays));

    final adjustedDateTimeRange = DateTimeRange(
      start: start,
      end: end,
    );

    return adjustedDateTimeRange;
  }

  @override
  int calculateDateIndex(DateTime date, DateTime startDate) {
    final index = date.difference(startDate).inDays ~/ numberOfDays;
    return index;
  }

  @override
  int calculateNumberOfPages(DateTimeRange adjustedDateTimeRange) {
    final numberOfPages = adjustedDateTimeRange.dayDifference ~/ numberOfDays;

    return numberOfPages;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
  }) {
    final start = DateTime(
      calendarStart.year,
      calendarStart.month,
      calendarStart.day + (index * numberOfDays),
    );

    final end = start.add(Duration(days: numberOfDays));

    return DateTimeRange(
      start: start,
      end: end,
    );
  }
}
