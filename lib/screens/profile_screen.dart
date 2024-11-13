import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:untitled1/models/profile_item.dart';

class ProfileScreen extends StatefulWidget {
  final int currentPoints;

  const ProfileScreen({
    Key? key,
    required this.currentPoints,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ProfileItem> _items = [];
  Map<String, ProfileItem> _equippedItems = {};
  String _selectedCategory = '배경';
  bool _showUnlockAnimation = false;
  ProfileItem? _justUnlockedItem;

  final List<String> _categories = ['배경', '캐릭터', '뱃지', '프레임'];

  @override
  void initState() {
    super.initState();
    _loadItems();
    _loadEquippedItems();
    _checkAndUnlockItems();
  }

  // 아이템 초기 데이터
  void _loadItems() {
    _items = [
      // 배경 아이템들
      ProfileItem(
        id: 'bg_1',
        name: '푸른 하늘',
        description: '맑은 하늘처럼 상쾌한 마음',
        requiredPoints: 100,
        category: '배경',
        imageAsset: 'assets/backgrounds/sky.png',
        tier: 1,
        unlockMessage: '첫 번째 배경을 해금했습니다! 맑은 하늘처럼 상쾌한 마음으로 시작해보세요.',
      ),
      ProfileItem(
        id: 'bg_2',
        name: '일출',
        description: '새로운 시작을 알리는 아침',
        requiredPoints: 300,
        category: '배경',
        imageAsset: 'assets/backgrounds/sunrise.png',
        tier: 2,
        unlockMessage: '두 번째 배경 해금! 새로운 아침이 밝았습니다.',
      ),
      // 캐릭터 아이템들
      ProfileItem(
        id: 'char_1',
        name: '건강한 토끼',
        description: '활기찬 토끼',
        requiredPoints: 200,
        category: '캐릭터',
        imageAsset: 'assets/characters/rabbit.png',
        tier: 1,
        unlockMessage: '첫 번째 캐릭터 해금! 건강한 토끼처럼 활기차게 시작해보세요.',
      ),
      ProfileItem(
        id: 'char_2',
        name: '운동하는 곰',
        description: '건강한 생활을 하는 곰',
        requiredPoints: 400,
        category: '캐릭터',
        imageAsset: 'assets/characters/bear.png',
        tier: 2,
        unlockMessage: '두 번째 캐릭터 해금! 건강한 생활을 실천하는 곰이 되어보세요.',
      ),
      // 뱃지 아이템들
      ProfileItem(
        id: 'badge_1',
        name: '첫 걸음',
        description: '금연 시작 1일 달성',
        requiredPoints: 50,
        category: '뱃지',
        imageAsset: 'assets/badges/first_step.png',
        tier: 1,
        unlockMessage: '첫 걸음 뱃지를 획득했습니다! 작은 시작이 큰 변화를 만듭니다.',
      ),
      ProfileItem(
        id: 'badge_2',
        name: '의지의 상징',
        description: '금연 7일 달성',
        requiredPoints: 500,
        category: '뱃지',
        imageAsset: 'assets/badges/willpower.png',
        tier: 2,
        unlockMessage: '의지의 상징 뱃지 획득! 당신의 의지가 빛나고 있습니다.',
      ),
      // 프레임 아이템들
      ProfileItem(
        id: 'frame_1',
        name: '골드 프레임',
        description: '고급스러운 골드 테두리',
        requiredPoints: 150,
        category: '프레임',
        imageAsset: 'assets/frames/gold.png',
        tier: 1,
        unlockMessage: '첫 번째 프레임 해금! 골드 프레임으로 프로필을 꾸며보세요.',
      ),
      ProfileItem(
        id: 'frame_2',
        name: '반짝이는 다이아',
        description: '빛나는 다이아몬드 테두리',
        requiredPoints: 600,
        category: '프레임',
        imageAsset: 'assets/frames/diamond.png',
        tier: 2,
        unlockMessage: '최고급 다이아 프레임 해금! 당신의 노력이 빛나는 순간입니다.',
      ),
    ];
  }

  // 아이템 잠금 해제 체크
  Future<void> _checkAndUnlockItems() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedItems = prefs.getStringList('unlockedItems') ?? [];

    bool newUnlock = false;

    for (var item in _items) {
      if (!unlockedItems.contains(item.id) &&
          widget.currentPoints >= item.requiredPoints) {
        // 새로운 아이템 해금
        unlockedItems.add(item.id);
        newUnlock = true;

        // 해금 축하 효과 표시
        _showUnlockCelebration(item);
      }
    }

    if (newUnlock) {
      await prefs.setStringList('unlockedItems', unlockedItems);
    }
  }

  // 해금 축하 효과 표시
  void _showUnlockCelebration(ProfileItem item) {
    setState(() {
      _justUnlockedItem = item;
      _showUnlockAnimation = true;
    });

    showDialog(
      context: context,
      builder: (context) => UnlockCelebrationDialog(item: item),
    );
  }

  Future<void> _loadEquippedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final equippedJson = prefs.getString('equippedItems');
    if (equippedJson != null) {
      final equipped = jsonDecode(equippedJson) as Map<String, dynamic>;
      setState(() {
        _equippedItems = equipped.map((key, value) =>
            MapEntry(key, ProfileItem.fromJson(value as Map<String, dynamic>)));
      });
    }
  }

  Future<void> _saveEquippedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final equippedJson = jsonEncode(
        _equippedItems.map((key, value) => MapEntry(key, value.toJson()))
    );
    await prefs.setString('equippedItems', equippedJson);
  }

  void _equipItem(ProfileItem item) {
    setState(() {
      _equippedItems[item.category] = item;
    });
    _saveEquippedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('프로필 꾸미기'),
    actions: [
    Center(
    child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
    children: [
    Icon(Icons.stars, color: Colors.amber),
    SizedBox(width: 4),
    Text(
    '${widget.currentPoints}P',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    body: Column(
    children: [
    // 프로필 미리보기
    Container(
    height: 200,
    margin: EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
    BoxShadow(
    color: Colors.black12,
    blurRadius: 10,
    spreadRadius: 1,
    ),
    ],
    ),
    child: Stack(
    children: [
    // 배경
    if (_equippedItems['배경'] != null)
    Positioned.fill(
    child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Image.asset(
    _equippedItems['배경']!.imageAsset,
    fit: BoxFit.cover,
    ),
    ),
    ),
    // 캐릭터
    if (_equippedItems['캐릭터'] != null)
    Center(
    child: Image.asset(
    _equippedItems['캐릭터']!.imageAsset,
    height: 120,
    ),
    ),
    // 프레임
    if (_equippedItems['프레임'] != null)
    Positioned.fill(
    child: Image.asset(
    _equippedItems['프레임']!.imageAsset,
    fit: BoxFit.cover,
    ),
    ),
    // 뱃지
    if (_equippedItems['뱃지'] != null)
    Positioned(
    top: 16,
    right: 16,
    child: Image.asset(
    _equippedItems['뱃지']!.imageAsset,
    height: 40,
    ),
    ),
    ],
    ),
    ),

    // 카테고리 선택
    Container(
    height: 50,
    child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: _categories.length,
    itemBuilder: (context, index) {
    final category = _categories[index];
    return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: ChoiceChip(
    label: Text(category),
    selected: _selectedCategory == category,
    onSelected: (selected) {
    setState(() {
    _selectedCategory = category;
    });
    },
    ),
    );
    },
    ),
    ),

    // 아이템 목록
    Expanded(
    child: GridView.builder(
    padding: EdgeInsets.all(16),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.8,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    ),
    itemCount: _items
        .where((item) => item.category == _selectedCategory)
        .length,
    itemBuilder: (context, index) {
    final item = _items
        .where((item) => item.category == _selectedCategory)
        .toList()[index];
    final isLocked = item.requiredPoints > widget.currentPoints;
    final isEquipped = _equippedItems[item.category]?.id == item.id;

    return GestureDetector(
    onTap: isLocked
    ? () {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(
    '${item.requiredPoints}P가 필요합니다. (현재: ${widget.currentPoints}P)'
    ),
    ),
    );
    }
        : () => _equipItem(item),
    child: Card(
    elevation: isEquipped ? 8 : 2,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: isEquipped
    ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
        : BorderSide.none,
    ),
    child: Stack(
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    Expanded(
    flex: 2,
    child: Container(
    decoration: BoxDecoration(
    color: Colors.grey[100],
    borderRadius: BorderRadius.vertical(
    top: Radius.circular(16),
    ),
    ),
    child: Stack(
    children: [
    Center(
    child: Image.asset(
    item.imageAsset,
    fit: BoxFit.cover,
    ),
    ),
    if (isLocked)
    Container(
    color: Colors.black45,
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    Icons.lock,
    color: Colors.white,
    size: 32,
    ),
    SizedBox(height: 4),
    Text(
    '${item.requiredPoints}P 필요',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    Expanded(
    flex: 1,
    child: Padding(
    padding: EdgeInsets.all(8),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    Expanded(
    child: Text(
    item.name,
    style: TextStyle(
    fontWeight: FontWeight.bold,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    ),
    ),
    Container(
    padding: EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
    ),
    decoration: BoxDecoration(
    color: _getTierColor(item.tier),
    borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
    'Tier ${item.tier}',
    style: TextStyle(
    color: Colors.white,
    fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ],
    ),
      SizedBox(height: 4),
      Text(
        item.description,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
    ),
    ),
    ),
    ],
    ),
      if (isEquipped)
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '착용중',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
    ],
    ),
    ),
    );
    },
    ),
    ),
    ],
    ),
    );
  }

  Color _getTierColor(int tier) {
    switch (tier) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

// 해금 축하 다이얼로그
class UnlockCelebrationDialog extends StatelessWidget {
  final ProfileItem item;

  const UnlockCelebrationDialog({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Icon(
              Icons.stars,
              size: 64,
              color: Colors.amber,
            ),
            SizedBox(height: 16),
            Text(
              '🎉 새로운 아이템 해금! 🎉',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                item.imageAsset,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 8),
            Text(
              item.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              item.unlockMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}