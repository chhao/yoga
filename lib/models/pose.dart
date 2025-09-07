class Pose {
  final String id;
  final String name;
  final String nameEn;
  final String nameSa;
  final String benefits;
  final String description;
  final int difficulty;
  final String akaChinese;
  final int position;
  final String type;

  Pose({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameSa,
    required this.benefits,
    required this.description,
    required this.difficulty,
    required this.akaChinese,
    required this.position,
    required this.type,
  });

  factory Pose.fromJson(Map<String, dynamic> json) {
    return Pose(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      nameSa: json['name_sa'],
      benefits: json['benefits'],
      description: json['description'],
      difficulty: json['difficulty'],
      akaChinese: json['aka_chinese'],
      position: json['position'],
      type: json['type'],
    );
  }

  String get difficulty_text {
    final difficultyMap = ['初级', '中级', '高级'];
    return difficultyMap[difficulty] ?? '未知';
  }

  String get position_text {
    final typeMap = {
      1: '站立',
      2: '坐姿',
      3: '仰卧',
      4: '俯卧',
      5: '跪姿',
      6: '平衡',
    };
    return typeMap[position] ?? '未知';
  }

  List<String> get benefits_array {
    return benefits.split('\n').where((s) => s.isNotEmpty).toList();
  }

  List<String> get steps_array {
    return description.split('\n').where((s) => s.isNotEmpty).toList();
  }

  List<String> get type_array {
    return type.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  String get detailimgurl {
    return 'assets/pose-img/' + id + '.png';
  }

  String get tbimageurl {
    return 'assets/pose-tb/tb_' + id + '.png';
  }
}
