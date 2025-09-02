class SequencePose {
  final String id;
  final int time;
  final String goal;

  SequencePose({required this.id, required this.time, required this.goal});

  factory SequencePose.fromJson(Map<String, dynamic> json) {
    return SequencePose(id: json['id'], time: json['time'], goal: json['goal']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'goal': goal,
    };
  }
}

class Sequence {
  final String id;
  final String name;
  final String englishName;
  final String scenario;
  final List<SequencePose> poses;

  Sequence({
    required this.id,
    required this.name,
    required this.englishName,
    required this.scenario,
    required this.poses,
  });

  factory Sequence.fromJson(Map<String, dynamic> json) {
    var posesList = json['poses'] as List;
    List<SequencePose> poses = posesList
        .map((i) => SequencePose.fromJson(i))
        .toList();

    return Sequence(
      id: json['id'],
      name: json['name'],
      englishName: json['englishName'],
      scenario: json['scenario'],
      poses: poses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'englishName': englishName,
      'scenario': scenario,
      'poses': poses.map((pose) => pose.toJson()).toList(),
    };
  }
}
