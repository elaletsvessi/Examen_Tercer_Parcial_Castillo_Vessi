import 'package:flutter/material.dart';
import 'package:fit_track_pro/features/auth/services/auth_services.dart';
import 'package:fit_track_pro/features/auth/widgets/custom_text_field.dart';
import 'package:fit_track_pro/features/workouts/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController(
    //asi se crea un controlador de texto para el campo de usuario
    text: "emilys", //le metemos el valor por defecto "emilys" para que aparezca en el campo de texto al iniciar la app
  );

  final TextEditingController _passwordController = TextEditingController(
    text: "emilyspass",
  );

  final AuthServices _authService = AuthServices();

  bool _isLoading = false;

  void _iniciarSesion() async {
    setState(() {
      _isLoading = true;
    });

    bool success = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inicio de sesion exitoso")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error al iniciar sesión")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'FitTrack Pro',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              CustomTextField(
                //Esto es un widget que nosotros creamos en lib/features/auth/widgets/custom_text_field.dart, que es un campo de texto personalizado que recibe un controlador de texto y una etiqueta
                controller: _usernameController, //controller es el controlador de texto que se pasa al widget CustomTextField para manejar el valor del campo de texto
                label: "Usuario", //si le quitamos controller, el campo de texto no tendra un valor por defecto y no podra manejar el valor del campo de texto
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: "Contraseña",
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _iniciarSesion,
                      child: Text(
                        "Iniciar sesión",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
