import 'package:flutter/material.dart';
import '../models/peso_model.dart';

class AddPesoScreen extends StatefulWidget {
  const AddPesoScreen({super.key});

  @override
  State<AddPesoScreen> createState() => _AddPesoScreenState();
}

class _AddPesoScreenState extends State<AddPesoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final nuevoRegistro = PesoModel(
        fecha: _fechaController.text,
        pesoKilos: double.parse(_pesoController.text),
      );
      
      Navigator.pop(context, nuevoRegistro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Registro de Peso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(labelText: 'Fecha (ej. 17 de Noviembre)'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La fecha no puede estar vacía';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _pesoController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number, 
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El peso no puede estar vacío';
                  }
                  final numero = double.tryParse(value);
                  if (numero == null || numero <= 0) {
                    return 'Debe ser un número mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _guardar,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}