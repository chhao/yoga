import 'package:yoga/generated/app_localizations.dart';

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

  String difficulty_text(AppLocalizations localizations) {
    final difficultyMap = [
      localizations.beginner,
      localizations.intermediate,
      localizations.advanced
    ];
    return difficultyMap.length > difficulty ? difficultyMap[difficulty] : localizations.unknown;
  }

  String position_text(AppLocalizations localizations) {
    final typeMap = {
      1: localizations.standing,
      2: localizations.seated,
      3: localizations.supine,
      4: localizations.prone,
      5: localizations.kneeling,
      6: localizations.balancing,
    };
    return typeMap[position] ?? localizations.unknown;
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