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
  final String bg;
  final String url;

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
    required this.bg,
    required this.url,
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
      bg: json['bg'],
      url: json['url'],
    );
  }
}
