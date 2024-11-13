import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_settings.dart';
import '../models/diary_entry.dart';
import '../models/profile_item.dart';

class StorageService {
  static const String userSettingsKey = 'userSettings';
  static const String diaryEntriesKey = 'diaryEntries';
  static const String unlockedItemsKey = 'unlockedItems';
  static const String equippedItemsKey = 'equippedItems';

  static Future<void> saveUserSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userSettingsKey, jsonEncode(settings.toJson()));
  }

  static Future<UserSettings?> getUserSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(userSettingsKey);
    if (settingsJson != null) {
      return UserSettings.fromJson(jsonDecode(settingsJson));
    }
    return null;
  }

  static Future<void> saveDiaryEntry(DiaryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getDiaryEntries();
    entries.add(entry);
    await prefs.setStringList(
      diaryEntriesKey,
      entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<List<DiaryEntry>> getDiaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(diaryEntriesKey) ?? [];
    return entriesJson
        .map((json) => DiaryEntry.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveUnlockedItems(List<String> itemIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(unlockedItemsKey, itemIds);
  }

  static Future<List<String>> getUnlockedItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(unlockedItemsKey) ?? [];
  }

  static Future<void> saveEquippedItems(Map<String, ProfileItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = items.map(
          (key, value) => MapEntry(key, jsonEncode(value.toJson())),
    );
    await prefs.setString(equippedItemsKey, jsonEncode(itemsJson));
  }

  static Future<Map<String, ProfileItem>> getEquippedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getString(equippedItemsKey);
    if (itemsJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(itemsJson);
      return decoded.map(
            (key, value) => MapEntry(
          key,
          ProfileItem.fromJson(jsonDecode(value)),
        ),
      );
    }
    return {};
  }
}