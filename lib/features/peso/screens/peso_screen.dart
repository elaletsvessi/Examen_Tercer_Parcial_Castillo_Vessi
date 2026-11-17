import 'package:flutter/material.dart';
import '../models/peso_model.dart';
import 'add_peso_screen.dart';

class PesoScreen extends StatefulWidget {
  const PesoScreen({super.key});

  @override
  State<PesoScreen> createState() => _PesoScreenState();
}

class _PesoScreenState extends State<PesoScreen> {
  // Lista temporal vacía iniciada en la pantalla principal
  List<PesoModel> registros = [];

  Future<void> _navegarYAgregarPeso() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPesoScreen()),
    );

    if (resultado != null && resultado is PesoModel) {
      setState(() {
        registros.add(resultado); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTrack Pro'),
      ),
      body: registros.isEmpty
          ? const Center(
              child: Text(
                'No hay registros',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    leading: const Icon(Icons.monitor_weight, color: Colors.blueAccent),
                    title: Text(
                      registro.fecha,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${registro.pesoKilos} kg',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarYAgregarPeso,
        child: const Icon(Icons.add),
      ),
    );
  }
}