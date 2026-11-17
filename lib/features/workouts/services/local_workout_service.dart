import '../models/workout_model.dart';
import '../../../core/database/database_helper.dart';

class LocalWorkoutService {
  final dbHelper = DatabaseHelper.instance;
  //crear rutina
  Future<int> insertWorkout(WorkoutModel workout) async {
    final db = await dbHelper.database;
    return await db.insert('workouts', workout.toMap());
  }

  //lectura de rutinas
  Future<List<WorkoutModel>> getWorkouts() async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('workouts');

    return List.generate(maps.length, (index) {
      return WorkoutModel.fromMap(maps[index]);
    });
  }

  //eliminar rutina
  Future<int> deleteWorkout(int id) async {
    final db = await dbHelper.database;
    return await db.delete('workouts', where: 'local_id = ?', whereArgs: [id]);
  }

  //actualizar rutina
  Future<int> updateWorkout(WorkoutModel workout) async {
    final db = await dbHelper.database;
    return await db.update(
      'workouts',
      workout.toMap(),
      where: 'local_id = ?',
      whereArgs: [workout.localId],
    );
  }
}
