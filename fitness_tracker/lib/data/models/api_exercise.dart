
class ApiExercise {
  final String name;
  final String type;
  final String muscle;
  final String equipment;
  final String difficulty;
  final String instructions;

const ApiExercise({
  required this.name,
  required this.type,
  required this.muscle,
  required this.equipment,
  required this.difficulty,
  required this.instructions,
});

factory ApiExercise.fromJson(Map<String, dynamic> json) {
  final exercises = json['exercises'] as Map<String, dynamic>;


  final _name = exercises['name'] as String;
  final _type = exercises['type'] as String;
  final _muscle = exercises['muscle'] as String;
  final _equipment = exercises['equipment'] as String;
  final _difficulty = exercises['difficulty'] as String;
  final _instructions = exercises['instructions'] as String;


  return ApiExercise(
    name: _name,
    type: _type,
    muscle: _muscle,
    equipment: _equipment,
    difficulty: _difficulty,
    instructions: _instructions,
  );
}

}
