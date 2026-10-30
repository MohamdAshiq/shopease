import 'package:shared_preferences/shared_preferences.dart';

// Service for managing recent search history
class SearchHistoryService {
  SearchHistoryService({this.prefs});

  static const _key = 'shopease_recent_searches';
  static const _maxEntries = 10;

  final SharedPreferences? prefs;

  Future<SharedPreferences> _getPrefs() async =>
      prefs ?? await SharedPreferences.getInstance();

  Future<List<String>> getRecentSearches() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(_key) ?? [];
  }

  Future<List<String>> addSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      return getRecentSearches();
    }

    final prefs = await _getPrefs();
    final current = prefs.getStringList(_key) ?? [];

    final updated = [
      trimmed,
      ...current.where((item) => item.toLowerCase() != trimmed.toLowerCase()),
    ].take(_maxEntries).toList();

    await prefs.setStringList(_key, updated);
    return updated;
  }

  Future<List<String>> removeSearch(String query) async {
    final prefs = await _getPrefs();
    final current = prefs.getStringList(_key) ?? [];
    final updated = current.where((item) => item != query).toList();
    await prefs.setStringList(_key, updated);
    return updated;
  }

  Future<void> clearHistory() async {
    final prefs = await _getPrefs();
    await prefs.remove(_key);
  }
}
