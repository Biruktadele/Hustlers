class Quote {
  final String text;
  final String author;

  const Quote({required this.text, required this.author});

  factory Quote.fromPair(List<String> pair) {
    final text = pair.isNotEmpty ? pair[0].trim() : '';
    final author = pair.length > 1 ? pair[1].trim() : '';
    return Quote(text: text, author: author);
  }
}

/// Deterministically picks today's quote based on the local calendar day.
///
/// This changes at local midnight (based on the device's current locale/timezone).
Quote quoteForLocalDay({
  required List<Quote> quotes,
  DateTime? now,
  Quote? fallback,
}) {
  if (quotes.isEmpty) {
    return fallback ?? const Quote(text: '', author: '');
  }

  final local = (now ?? DateTime.now()).toLocal();

  // Use a stable integer key for YYYY-MM-DD.
  // We map the local calendar day to a UTC day number to avoid timezone offsets
  // affecting the modulo calculation.
  final dayNumber =
      DateTime.utc(local.year, local.month, local.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  final index = dayNumber % quotes.length;
  return quotes[index];
}
