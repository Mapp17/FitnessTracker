class Exercise {
  final String id;
  final String name;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  double get volume => sets * reps * weight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Exercise && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Exercise copyWith({
    String? name,
    int? muscleGroup,
    int? sets,
    int? reps,
    double? weight,
  }) {
    return Exercise(
      id: id,
      name: name ?? this.name,
      muscleGroup: muscleGroup != null ? muscleGroup.toString() : this.muscleGroup,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'muscleGroup': muscleGroup,
    'sets': sets,
    'reps': reps,
    'weight': weight,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      muscleGroup: json['muscleGroup'],
      sets: json['sets'],
      reps: json['reps'],
      weight: (json['weight'] as num).toDouble(),
    );
  }
}