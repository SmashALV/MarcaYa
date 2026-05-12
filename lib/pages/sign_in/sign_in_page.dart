import 'package:flutter/material.dart';
import '../../src/app_state.dart';
import '../resumen_empleado/resumen_empleado.dart';
import '../resumen_empresa/resumen_empresa.dart';

bool rememberUser = false;
final emailController = TextEditingController();

final passwordController = TextEditingController();


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool rememberUser = false;

  final Color backgroundColor = const Color(0xFF111111);
  final Color textFieldColor = const Color(0xFF5A5A5A);
  final Color buttonColor = const Color(0xFFFFB800);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // LOGO
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 40),

              // USERNAME
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: textFieldColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // PASSWORD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: textFieldColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CHECKBOX
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Row(
                  children: [
                    Checkbox(
                      value: rememberUser,
                      activeColor: buttonColor,
                      checkColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          rememberUser = value!;
                        });
                      },
                    ),
                    const Text(
                      'Recordar usuario',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // BUTTON
              SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {

                    final state = MarcAppState();

                    final success = state.login(
                      emailController.text,
                      passwordController.text,
                    );

                    if (success) {

                      if (state.currentUser?.role == UserRole.employee) {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResumenEmpleadoPage(),
                          ),
                        );

                      } else if (state.currentUser?.role == UserRole.admin) {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResumenEmpresaPage(),
                          ),
                        );

                      }

                    }

                  },
                  child: const Text(
                    'INICIAR SESIÓN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 90),

              // TEXTS
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      '¿Ha olvidado su contraseña? Haga click aquí',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '¿Aún no es miembro? Regístrese ahora',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}