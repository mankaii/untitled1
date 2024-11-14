import 'package:flutter/material.dart';
import 'package:untitled1/models/profile_item.dart';

class ProfileProvider with ChangeNotifier {
  Map<String, ProfileItem> _equippedItems = {};

  Map<String, ProfileItem> get equippedItems => _equippedItems;

  void updateEquippedItem(String category, ProfileItem item) {
    _equippedItems[category] = item;
    notifyListeners();
  }

  void refreshHomeScreen() {
    notifyListeners();
  }
}