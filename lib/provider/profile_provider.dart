import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:untitled1/models/profile_item.dart';

class ProfileProvider with ChangeNotifier {
  Map<String, ProfileItem> _equippedItems = {};

  ProfileProvider() {
    _loadEquippedItems();
  }

  Map<String, ProfileItem> get equippedItems => _equippedItems;

  // 초기 아이템 설정
  Future<void> _loadEquippedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getString('equippedItems');

    if (itemsJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(itemsJson);
      _equippedItems = decoded.map(
            (key, value) => MapEntry(key, ProfileItem.fromJson(value)),
      );
    } else {
      // 초기 프로필 설정
      _equippedItems = {
        '배경': ProfileItem(
          id: 'bg_1',
          name: '마을',
          description: '새로운 시작을 알리는 마을',
          requiredPoints: 0,
          category: '배경',
          imageAsset: 'assets/backgrounds/hill.jpg',
          tier: 1,
          unlockMessage: '첫 배경 해금! 새로운 아침이 밝았습니다.',
        ),
        '캐릭터': ProfileItem(
          id: 'char_1',
          name: '스털링',
          description: '가장 털털한 스털링',
          requiredPoints: 10,
          category: '캐릭터',
          imageAsset: 'assets/characters/basicSterling.png',
          tier: 1,
          unlockMessage: '첫 번째 캐릭터 해금! 스털링과 활기차게 시작해보세요.',
        ),
      };
      _saveEquippedItems();
    }
    notifyListeners();
  }

  // 아이템 장착
  Future<void> equipItem(ProfileItem item) async {
    _equippedItems[item.category] = item;
    await _saveEquippedItems();
    notifyListeners();
  }

  // 장착한 아이템 저장
  Future<void> _saveEquippedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final equippedJson = jsonEncode(
      _equippedItems.map((key, value) => MapEntry(key, value.toJson())),
    );
    await prefs.setString('equippedItems', equippedJson);
  }

  void refreshHomeScreen() {
    notifyListeners();
  }
}