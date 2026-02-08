import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/daily_quotes.dart';
import 'daily_quote.dart';

final dailyQuoteProvider = NotifierProvider<DailyQuoteController, Quote>(
  DailyQuoteController.new,
);

class DailyQuoteController extends Notifier<Quote> {
  Timer? _timer;

  @override
  Quote build() {
    ref.onDispose(() => _timer?.cancel());
    _scheduleNextUpdate();
    return _computeQuote(now: DateTime.now());
  }

  Quote _computeQuote({required DateTime now}) {
    final quotes = dailyQuotesRaw
        .where((pair) => pair.length >= 2)
        .map((pair) => Quote.fromPair(pair))
        .where((q) => q.text.isNotEmpty)
        .toList(growable: false);

    if (quotes.isEmpty) {
      return const Quote(
        text: 'Keep going — small steps add up.',
        author: 'Hustlers',
      );
    }

    // Change quote every 12 hours based on global time
    // This ensures it doesn't always start at index 0 when the app opens.
    final intervalMs = const Duration(hours: 12).inMilliseconds;
    final slot = now.millisecondsSinceEpoch ~/ intervalMs;
    final index = slot % quotes.length;
    return quotes[index];
  }

  void _scheduleNextUpdate() {
    _timer?.cancel();

    // Calculates how many milliseconds are left until the next 12-hour boundary.
    final now = DateTime.now();
    final intervalMs = const Duration(hours: 12).inMilliseconds;
    final msUntilNext = intervalMs - (now.millisecondsSinceEpoch % intervalMs);

    _timer = Timer(Duration(milliseconds: msUntilNext), () {
      state = _computeQuote(now: DateTime.now());
      // Once aligned, run periodically
      _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
        state = _computeQuote(now: DateTime.now());
      });
    });
  }
}
