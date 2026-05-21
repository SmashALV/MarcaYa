import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../codigo_contrasena/codigo_contrasena.dart';

class RegistrarEmpleadoPage extends StatefulWidget {
  const RegistrarEmpleadoPage({super.key});

  @override
  State<RegistrarEmpleadoPage> createState() => _RegistrarEmpleadoPageState();
}

class _RegistrarEmpleadoPageState extends State<RegistrarEmpleadoPage> {
  static const _backgroundColor = Color(0xFFF6FAF8);
  static const _cardColor = Colors.white;
  static const _primaryColor = Color(0xFF34A0A4);
  static const _titleColor = Color(0xFF184E77);
  static const _fieldBorderColor = Color(0xFFDDE3EA);
  static const _hintColor = Color(0xFF98A2B3);

  final _nombreController = TextEditingController();
  final _dniController = TextEditingController();
  final _correoController = TextEditingController();
  final _claveController = TextEditingController();
  final _confirmarController = TextEditingController();

  String? _error;

  @override
  void dispose() {
    _nombreController.dispose();
    _dniController.dispose();
    _correoController.dispose();
    _claveController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  void _continuar() {
    final nombre = _nombreController.text.trim();
    final dni = _dniController.text.trim();
    final correo = _correoController.text.trim();
    final clave = _claveController.text;
    final confirmar = _confirmarController.text;

    if ([nombre, dni, correo, clave, confirmar].any((value) => value.isEmpty)) {
      setState(() => _error = 'Completa todos los campos');
      return;
    }

    if (dni.length != 8) {
      setState(() => _error = 'El DNI debe tener 8 digitos');
      return;
    }

    if (clave != confirmar) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }

    setState(() => _error = null);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CodigoContrasenaPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
                child: Column(
                  children: [
                    _RegistroInput(
                      hintText: 'Nombre de usuario',
                      controller: _nombreController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 17),
                    _RegistroInput(
                      hintText: 'DNI',
                      controller: _dniController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                    ),
                    const SizedBox(height: 17),
                    _RegistroInput(
                      hintText: 'Correo electrónico',
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 17),
                    _RegistroInput(
                      hintText: 'Contraseña',
                      controller: _claveController,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 17),
                    _RegistroInput(
                      hintText: 'Confirmar contraseña',
                      controller: _confirmarController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _continuar(),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          elevation: 2,
                          shadowColor: const Color(0x3334A0A4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _continuar,
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: _RegistrarEmpleadoPageState._cardColor,
        border: Border(bottom: BorderSide(color: Color(0xFFEFF2F5))),
      ),
      child: Row(
        children: [
          const SizedBox(width: 22),
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 19,
              color: _RegistrarEmpleadoPageState._titleColor,
            ),
            tooltip: 'Volver',
          ),
          const SizedBox(width: 8),
          const Text(
            'Registrar empleado',
            style: TextStyle(
              color: _RegistrarEmpleadoPageState._titleColor,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistroInput extends StatelessWidget {
  const _RegistroInput({
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.inputFormatters,
    this.onSubmitted,
  });

  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        onSubmitted: onSubmitted,
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: _RegistrarEmpleadoPageState._hintColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: _RegistrarEmpleadoPageState._cardColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: _RegistrarEmpleadoPageState._fieldBorderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: _RegistrarEmpleadoPageState._fieldBorderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: _RegistrarEmpleadoPageState._primaryColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
