import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class CorrectBookRepository {
  CorrectBookRepository({
    SharedPreferencesAsync? preferences,
    Random? random,
  })  : _preferences = preferences ?? SharedPreferencesAsync(),
        _random = random ?? Random();

  static const String _correctBookKey =
      'act_two_correct_book_index';

  final SharedPreferencesAsync _preferences;
  final Random _random;

  Future<int> getOrCreateCorrectBookIndex({
    required int totalBooks,
  }) async {
    if (totalBooks <= 0) {
      throw ArgumentError.value(
        totalBooks,
        'totalBooks',
        'A quantidade de livros deve ser maior que zero.',
      );
    }

    final savedIndex = await _preferences.getInt(
      _correctBookKey,
    );

    if (savedIndex != null &&
        savedIndex >= 0 &&
        savedIndex < totalBooks) {
      return savedIndex;
    }

    final generatedIndex = _random.nextInt(totalBooks);

    await _preferences.setInt(
      _correctBookKey,
      generatedIndex,
    );

    return generatedIndex;
  }
}