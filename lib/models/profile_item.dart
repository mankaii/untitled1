// models/profile_item.dart
class ProfileItem {
  final String id;
  final String name;
  final String description;
  final int requiredPoints;
  final String category;
  final String imageAsset;
  final bool isLocked;
  final int tier;  // 티어 추가 (1, 2, 3 등)
  final String unlockMessage;  // 해금 시 표시할 메시지

  ProfileItem({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredPoints,
    required this.category,
    required this.imageAsset,
    required this.tier,
    required this.unlockMessage,
    this.isLocked = true,
  });

  ProfileItem copyWith({bool? isLocked}) {
    return ProfileItem(
      id: id,
      name: name,
      description: description,
      requiredPoints: requiredPoints,
      category: category,
      imageAsset: imageAsset,
      tier: tier,
      unlockMessage: unlockMessage,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'requiredPoints': requiredPoints,
    'category': category,
    'imageAsset': imageAsset,
    'isLocked': isLocked,
    'tier': tier,
    'unlockMessage': unlockMessage,
  };

  factory ProfileItem.fromJson(Map<String, dynamic> json) => ProfileItem(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    requiredPoints: json['requiredPoints'],
    category: json['category'],
    imageAsset: json['imageAsset'],
    tier: json['tier'],
    unlockMessage: json['unlockMessage'],
    isLocked: json['isLocked'],
  );
}

// 아이템 목록 정의
class ProfileItems {
  static final List<ProfileItem> items = [
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
      name: '다이아 프레임',
      description: '빛나는 다이아몬드 테두리',
      requiredPoints: 600,
      category: '프레임',
      imageAsset: 'assets/frames/diamond.png',
      tier: 2,
      unlockMessage: '최고급 다이아 프레임 해금! 당신의 노력이 빛나는 순간입니다.',
    ),
  ];
}