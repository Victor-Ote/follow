class ClosingMetadata {
  const ClosingMetadata({
    required this.date,
    required this.time,
  });

  final String date;
  final String time;

  String get formattedValue {
    return '$date • $time';
  }
}

const ClosingMetadata closingMetadata =
    ClosingMetadata(
  date: '03/08/2026',
  time: '01:08',
);