class BreathName {
  final String zh;
  final String en;
  final String sanskrit;
  final List<String> aliases;

  BreathName({
    required this.zh,
    required this.en,
    required this.sanskrit,
    required this.aliases,
  });

  factory BreathName.fromJson(Map<String, dynamic> json) {
    return BreathName(
      zh: json['zh'],
      en: json['en'],
      sanskrit: json['sanskrit'],
      aliases: List<String>.from(json['aliases'] ?? []),
    );
  }
}

class BreathRhythm {
  final String instruction;
  int duration;
  final int size;
  final String color;
  final String glow;

  BreathRhythm({
    required this.instruction,
    required this.duration,
    required this.size,
    required this.color,
    required this.glow,
  });

  factory BreathRhythm.fromJson(Map<String, dynamic> json) {
    return BreathRhythm(
      instruction: json['instruction'],
      duration: json['duration'],
      size: json['size'],
      color: json['color'],
      glow: json['glow'],
    );
  }
}

class BreathMethod {
  final String id;
  final BreathName name;
  final String image;
  final String summary;
  final String? origin; // Made nullable
  final List<String> audience;
  final List<String> benefits;
  final List<String> steps;
  final String? steptip; // Made nullable
  List<BreathRhythm> rhythm;
  final List<String> recommendations;
  final List<String> cautions;
  final String? tips; // Made nullable
  final List<String> keywords;
  String? imageUrl; // Added for convenience

  BreathMethod({
    required this.id,
    required this.name,
    required this.image,
    required this.summary,
    this.origin,
    required this.audience,
    required this.benefits,
    required this.steps,
    this.steptip,
    required this.rhythm,
    required this.recommendations,
    required this.cautions,
    this.tips,
    required this.keywords,
    this.imageUrl,
  });

  factory BreathMethod.fromJson(Map<String, dynamic> json) {
    return BreathMethod(
      id: json['id'],
      name: BreathName.fromJson(json['name']),
      image: json['image'],
      summary: json['summary'],
      origin: json['origin'] as String?, // Handle as nullable
      audience: List<String>.from(json['audience'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      steptip: json['steptip'] as String?, // Handle as nullable
      rhythm:
          (json['rhythm'] as List?)
              ?.map((i) => BreathRhythm.fromJson(i))
              .toList() ??
          [], // Handle as nullable list
      recommendations: List<String>.from(json['recommendations'] ?? []),
      cautions: List<String>.from(json['cautions'] ?? []),
      tips: json['tips'] as String?, // Handle as nullable
      keywords: List<String>.from(json['keywords'] ?? []),
      imageUrl: 'assets/breath-img/${json['image']}',
    );
  }
}
