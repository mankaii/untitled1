import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:untitled1/models/profile_item.dart';
import '../provider/profile_provider.dart';

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

  final List<String> _categories = ['배경', '캐릭터', '뱃지'];

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
        name: '마을',
        description: '새로운 시작을 알리는 마을',
        requiredPoints: 0,
        category: '배경',
        imageAsset: 'assets/backgrounds/hill.jpg',
        tier: 1,
        unlockMessage: '첫 배경 해금! 새로운 아침이 밝았습니다.',
      ),
      ProfileItem(
        id: 'bg_2',
        name: '푸른 하늘',
        description: '맑은 하늘처럼 상쾌한 마음',
        requiredPoints: 100,
        category: '배경',
        imageAsset: 'assets/backgrounds/sky.png',
        tier: 2,
        unlockMessage: '맑은 하늘처럼 상쾌한 마음으로 시작해보세요.',
      ),
      ProfileItem(
        id: 'bg_3',
        name: '경찰서 앞',
        description: '난 떳떳하다구',
        requiredPoints: 300,
        category: '배경',
        imageAsset: 'assets/backgrounds/police.jpg',
        tier: 3,
        unlockMessage: '배경 해금! 이번엔 경찰서 앞에서 보네요.',
      ),
      ProfileItem(
        id: 'bg_4',
        name: '전철역',
        description: '어딜 가는 걸까요?',
        requiredPoints: 500,
        category: '배경',
        imageAsset: 'assets/backgrounds/station.jpg',
        tier: 4,
        unlockMessage: '배경 해금! 어딜 가시려구요?',
      ),
      ProfileItem(
        id: 'bg_5',
        name: '경복궁',
        description: '아름다운 서울의 랜드마크죠',
        requiredPoints: 1000,
        category: '배경',
        imageAsset: 'assets/backgrounds/moonhwajae.jpg',
        tier: 4,
        unlockMessage: '배경 해금! 경복궁 한 번 보고가는거 어때요?',
      ),
      ProfileItem(
        id: 'bg_6',
        name: '고향',
        description: '가장 따뜻한 마을',
        requiredPoints: 3000,
        category: '배경',
        imageAsset: 'assets/backgrounds/hometown.jpg',
        tier: 4,
        unlockMessage: '마지막 배경 해금! 고향은 가장 아름다운 마을이죠.',
      ),

      // 캐릭터 아이템들
      ProfileItem(
        id: 'char_1',
        name: '스털링',
        description: '가장 털털한 스털링',
        requiredPoints: 10,
        category: '캐릭터',
        imageAsset: 'assets/characters/basicSterling.png',
        tier: 1,
        unlockMessage: '첫 번째 캐릭터 해금! 스털링과 활기차게 시작해보세요.',
      ),
      ProfileItem(
        id: 'char_2',
        name: '운동 스털링',
        description: '건강한 생활을 하는 스털링',
        requiredPoints: 100,
        category: '캐릭터',
        imageAsset: 'assets/characters/workOutSterling.png',
        tier: 2,
        unlockMessage: '두 번째 캐릭터 해금! 건강한 생활을 실천하는 스털링과 함께해요.',
      ),
      ProfileItem(
        id: 'char_3',
        name: '개발자 스털링',
        description: '개발에 지친 스털링',
        requiredPoints: 300,
        category: '캐릭터',
        imageAsset: 'assets/characters/developerSterling.png',
        tier: 3,
        unlockMessage: '세 번째 캐릭터 해금! 지친 개발자 스털링을 위로해서 함께 아자아자!',
      ),
      ProfileItem(
        id: 'char_4',
        name: '비즈니스맨 스털링',
        description: '사회에서 인정받는 스털링',
        requiredPoints: 500,
        category: '캐릭터',
        imageAsset: 'assets/characters/BusinessSterling.png',
        tier: 4,
        unlockMessage: '네 번째 캐릭터 해금! 바쁜 일상 속 살아남기! 비즈니스맨 스털링과 함께해요.',
      ),
      ProfileItem(
        id: 'char_5',
        name: '소녀 스털링',
        description: '발랄하고 상큼한 소녀 스털링',
        requiredPoints: 700,
        category: '캐릭터',
        imageAsset: 'assets/characters/girlSterling.png',
        tier: 5,
        unlockMessage: '다섯 번째 캐릭터 해금! 소녀 스털링과 함께 행복 가득한 여정을 떠나보세요!',
      ),
      ProfileItem(
        id: 'char_6',
        name: '태권도 스털링',
        description: '강인한 태권도숭이 스털링',
        requiredPoints: 900,
        category: '캐릭터',
        imageAsset: 'assets/characters/taekwondoSterling.png',
        tier: 6,
        unlockMessage: '여섯 번째 캐릭터 해금! 태권도 스털링과 함께 강인함을 키워보세요!',
      ),
      ProfileItem(
        id: 'char_7',
        name: '기본 스털링',
        description: '가장 베이직한 모습의 스털링',
        requiredPoints: 1200,
        category: '캐릭터',
        imageAsset: 'assets/characters/sterling.png',
        tier: 7,
        unlockMessage: '스털링 해금! 스털링과 여정을 함께 시작해봅시다!',
      ),
      ProfileItem(
        id: 'char_8',
        name: '학생 스털링',
        description: '배움을 추구하는 스털링',
        requiredPoints: 1500,
        category: '캐릭터',
        imageAsset: 'assets/characters/studentGirlSterling.png',
        tier: 8,
        unlockMessage: '여덟 번째 캐릭터 해금! 학구적인 스털링과 함께 성장해봐요!',
      ),
      ProfileItem(
        id: 'char_9',
        name: '부자 스털링',
        description: '화려한 생활을 즐기는 스털링',
        requiredPoints: 3000,
        category: '캐릭터',
        imageAsset: 'assets/characters/richSterling.png',
        tier: 9,
        unlockMessage: '마지막 캐릭터 해금! 부자 스털링과 함께 성공을 향해 나아가요!',
      ),
      // 뱃지 아이템들
      ProfileItem(
        id: 'badge_1',
        name: '금연할테야',
        description: '당신의 의지가 불타오릅니다',
        requiredPoints: 0,
        category: '뱃지',
        imageAsset: 'assets/badges/noSmoke.png',
        tier: 1,
        unlockMessage: '금연 파이팅!.',
      ),
      ProfileItem(
        id: 'badge_2',
        name: '첫 걸음',
        description: '금연 시작 1일 달성',
        requiredPoints: 50,
        category: '뱃지',
        imageAsset: 'assets/badges/first_step.png',
        tier: 2,
        unlockMessage: '첫 걸음 뱃지를 획득했습니다! 작은 시작이 큰 변화를 만듭니다.',
      ),
      ProfileItem(
        id: 'badge_3',
        name: '바나나',
        description: '금연 3일 달성',
        requiredPoints: 150,
        category: '뱃지',
        imageAsset: 'assets/badges/banana.png',
        tier: 3,
        unlockMessage: '스털링이 사랑하는 바나나군요!',
      ),
      ProfileItem(
        id: 'badge_4',
        name: '나무',
        description: '제법인데요',
        requiredPoints: 300,
        category: '뱃지',
        imageAsset: 'assets/badges/babytree.png',
        tier: 4,
        unlockMessage: '당신의 빛나는 의지가 꽃피운 나무입니다.',
      ),
      ProfileItem(
        id: 'badge_5',
        name: '왕관',
        description: '당신은 대단해요',
        requiredPoints: 10000,
        category: '뱃지',
        imageAsset: 'assets/badges/crown.png',
        tier: 5,
        unlockMessage: '금연을 거의 달성한 당신. 의지력이 참 대단해요.',
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

  void _equipItem(ProfileItem item) async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    await provider.equipItem(item);
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
              child: Consumer<ProfileProvider>(
                builder: (context, provider, _) {
                  return Row(
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          final equippedItems = provider.equippedItems;
          return Column(
            children: [
              // 프로필 미리보기
              Container(
                height: 400,
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
                    if (equippedItems['배경'] != null)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            equippedItems['배경']!.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  'Error loading background: ${equippedItems['배경']!
                                      .imageAsset}');
                              return Container(color: Colors.grey[100]);
                            },
                          ),
                        ),
                      ),
                    // 캐릭터
                    if (equippedItems['캐릭터'] != null)
                      Center(
                        child: Image.asset(
                          equippedItems['캐릭터']!.imageAsset,
                          height: 400,
                          errorBuilder: (context, error, stackTrace) {
                            print(
                                'Error loading character: ${equippedItems['캐릭터']!
                                    .imageAsset}');
                            return Icon(
                                Icons.person, size: 80, color: Colors.grey);
                          },
                        ),
                      ),

                    // 뱃지
                    if (equippedItems['뱃지'] != null)
                      Positioned(
                        top: 20,
                        right: 10,
                        child: Image.asset(
                          equippedItems['뱃지']!.imageAsset,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading badge: ${equippedItems['뱃지']!
                                .imageAsset}');
                            return Icon(
                                Icons.stars, size: 30, color: Colors.amber);
                          },
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
                    final isEquipped = equippedItems[item.category]?.id ==
                        item.id;

                    return GestureDetector(
                      onTap: isLocked
                          ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${item.requiredPoints}P가 필요합니다. (현재: ${widget
                                  .currentPoints}P)',
                            ),
                          ),
                        );
                      }
                          : () => provider.equipItem(item),
                      child: Card(
                        elevation: isEquipped ? 8 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: isEquipped
                              ? BorderSide(color: Theme
                              .of(context)
                              .primaryColor, width: 2)
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
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error,
                                                stackTrace) {
                                              print('Error loading item: ${item
                                                  .imageAsset}');
                                              return Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
                                        ),
                                        if (isLocked)
                                          Container(
                                            color: Colors.black45,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Icon(
                                                    Icons.lock,
                                                    color: Colors.white,
                                                    size: 32,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    '${item
                                                        .requiredPoints}P 필요',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight
                                                          .bold,
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
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
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
                                                borderRadius: BorderRadius
                                                    .circular(8),
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
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
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
          );
        },
      ),
    );
  }
}

// _getTierColor 메서드
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

// UnlockCelebrationDialog 클래스
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Icon(
              Icons.stars,
              size: 64,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Text(
              '🎉 새로운 아이템 해금! 🎉',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading celebration item: ${item.imageAsset}');
                  return Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.unlockMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}