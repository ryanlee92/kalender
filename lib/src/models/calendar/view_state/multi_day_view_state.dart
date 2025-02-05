import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/view_state/view_state.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

/// The viewState for the [MultiDayView].
class MultiDayViewState extends ViewState {
  MultiDayViewState({
    required super.visibleDateTimeRange,
    required this.viewConfiguration,
    required this.heightPerMinute,
    required this.adjustedDateTimeRange,
    required this.numberOfPages,
    required this.pageController,
    required this.scrollController,
  });

  /// Creates a [MultiDayViewState] from a [MultiDayViewConfiguration].
  factory MultiDayViewState.fromViewConfiguration({
    required DateTimeRange dateTimeRange,
    required DateTime selectedDate,
    required MultiDayViewConfiguration viewConfiguration,
    required MultiDayViewState? previousState,
  }) {
    final adjustedDateTimeRange = viewConfiguration.calculateAdjustedDateTimeRange(
      dateTimeRange: dateTimeRange,
      visibleStart: selectedDate,
    );

    final numberOfPages = viewConfiguration.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    final initialPage = viewConfiguration.calculateDateIndex(
      selectedDate,
      adjustedDateTimeRange.start,
    );

    final pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 1 / viewConfiguration.numberOfDaysReal,
    );

    final visibleDateRange = viewConfiguration.calculateVisibleDateTimeRange(
      selectedDate,
    );

    final scrollController = ScrollController(
      keepScrollOffset: true,
      initialScrollOffset: previousState?.lastKnowScrollOffset ?? 0.0,
    );

    scrollController.addListener(() {
      previousState?.lastKnowScrollOffset = scrollController.offset;
    });

    return MultiDayViewState(
      visibleDateTimeRange: ValueNotifier(visibleDateRange),
      viewConfiguration: viewConfiguration,
      adjustedDateTimeRange: adjustedDateTimeRange,
      numberOfPages: numberOfPages,
      pageController: pageController,
      scrollController: scrollController,
      heightPerMinute: previousState?.heightPerMinute ?? ValueNotifier(viewConfiguration.heightPerMinute),
    );
  }

  @override
  final MultiDayViewConfiguration viewConfiguration;

  @override
  set visibleDateTimeRange(DateTimeRange value) {
    visibleDateTimeRangeNotifier.value = value;
    visibleMonth = visibleDateTimeRangeNotifier.value.start.startOfMonth;
  }

  /// The pageController of the current view.
  final PageController pageController;

  /// The scrollController of the current view.
  final ScrollController scrollController;
  double lastKnowScrollOffset = 0.0;

  /// The height per minute of the current view.
  final ValueNotifier<double> heightPerMinute;

  /// The scrollPhysics of the current view.
  ValueNotifier<ScrollPhysics> scrollPhysics = ValueNotifier<ScrollPhysics>(const ScrollPhysics());

  /// The adjusted dateTimeRange of the current view.
  @override
  final DateTimeRange adjustedDateTimeRange;

  /// The number of pages the [PageView] of the current view has.
  final int numberOfPages;

  @override
  void adjustHeightPerMinute(double heightPerMinute) {
    this.heightPerMinute.value = heightPerMinute;
  }

  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    final pageNumber = viewConfiguration.calculateDateIndex(
      date,
      adjustedDateTimeRange.start,
    );

    await pageController.animateToPage(
      pageNumber,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToEvent(
    CalendarEvent event, {
    Duration? duration,
    Curve? curve,
    bool centerEvent = true,
  }) async {
    // First animate to the date of the event.
    await animateToDate(
      event.dateTimeRange.start,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.ease,
    );
    // Calculate the event position.
    final eventPosition = event.start.difference(event.start.startOfDay).inMinutes * heightPerMinute.value;

    double scrollPosition;

    if (centerEvent) {
      // Calculate the event height.
      final eventHeight = event.duration.inMinutes * heightPerMinute.value;

      // If the event is smaller than the viewport, center the event.
      if (eventHeight < scrollController.position.viewportDimension) {
        // Calculate the scroll position to center the event.
        scrollPosition = eventPosition - (scrollController.position.viewportDimension - eventHeight) / 2;
      } else {
        scrollPosition = eventPosition;
      }
    } else {
      scrollPosition = eventPosition;
    }

    // Animate to the event position.
    scrollController.animateTo(
      scrollPosition,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.ease,
    );
  }

  @override
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  }) async {
    await pageController.nextPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  }) async {
    await pageController.previousPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void jumpToDate(DateTime date) {
    // Calculate the page number of the given date.
    final pageNumber = viewConfiguration.calculateDateIndex(
      date,
      adjustedDateTimeRange.start,
    );

    // Jump to the page.
    jumpToPage(pageNumber);
  }

  @override
  void jumpToPage(int page) {
    pageController.jumpToPage(page);
  }

  @override
  operator ==(Object other) {
    return other is MultiDayViewState &&
        other.visibleDateTimeRange == visibleDateTimeRange &&
        other.adjustedDateTimeRange == adjustedDateTimeRange &&
        other.numberOfPages == numberOfPages &&
        other.pageController == pageController &&
        other.scrollController == scrollController;
  }

  @override
  int get hashCode {
    return Object.hash(
      visibleDateTimeRange,
      adjustedDateTimeRange,
      numberOfPages,
      pageController,
      scrollController,
    );
  }
}
