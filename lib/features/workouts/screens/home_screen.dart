import 'package:flutter/material.dart';

import '../../../core/storage/local_storage_service.dart';
import '../../auth/screens/login_screen.dart';
import '../../peso/screens/peso_screen.dart'; 
import '../models/workout_model.dart';
import '../services/local_workout_service.dart';
import 'add_workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalWorkoutService _dbService = LocalWorkoutService();

  List<WorkoutModel> _workouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      _isLoading = true;
    });

    final workouts = await _dbService.getWorkouts();

    setState(() {
      _workouts = workouts;
      _isLoading = false;
    });
  }

  void _logout() async {
    final storage = LocalStorageService();
    await storage.clearToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _navigateToAddWorkoutScreen() async {
    final newWorkout = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWorkoutScreen()),
    );

    if (newWorkout != null && newWorkout is WorkoutModel) {
      await _dbService.insertWorkout(newWorkout);
      _loadWorkouts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Rutina agregada: ${newWorkout.title}")),
        );
      }
    }
  }

  Future<void> _deleteWorkout(int localId) async {
    await _dbService.deleteWorkout(localId);
    if (mounted) {
      _loadWorkouts();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Rutina eliminada: $localId"))
      );
    }
  }

  void _showEditWorkoutDialog(WorkoutModel workout) {
    final titleController = TextEditingController(text: workout.title);
    final categoryController = TextEditingController(text: workout.category);
    final durationMinutesController =
        TextEditingController(text: workout.durationMinutes.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar rutina'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Categoria"),
            ),
            TextField(
              controller: durationMinutesController,
              decoration: const InputDecoration(labelText: "Duración (minutos)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  durationMinutesController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty) {
                final updatedWorkout = WorkoutModel(
                  localId: workout.localId,
                  title: titleController.text,
                  category: categoryController.text,
                  durationMinutes: int.parse(durationMinutesController.text),
                );
                await _dbService.updateWorkout(updatedWorkout);

                if (mounted) {
                  Navigator.pop(context);
                  _loadWorkouts();
                }
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis entrenamientos"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          // Botón para acceder al nuevo módulo de peso
          IconButton(
            icon: const Icon(Icons.monitor_weight),
            tooltip: 'Historial de Peso',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PesoScreen()),
              );
            },
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Cerrar sesión"),
                  content: const Text("¿Estás seguro de que quieres cerrar sesión?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Cerrar sesión",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _workouts.isEmpty
              ? const Center(child: Text('No tienes rutinas creadas'))
              : ListView.builder(
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    final workout = _workouts[index];
                    return GestureDetector(
                      onTap: () => _showEditWorkoutDialog(workout),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.fitness_center)),
                          title: Text(
                            workout.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            onPressed: () => _deleteWorkout(workout.localId!),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          subtitle: Text(
                            '${workout.category}\n${workout.durationMinutes} min',
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddWorkoutScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}