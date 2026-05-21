import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../nueva_contrasena/nueva_contrasena.dart';

class CodigoContrasenaPage extends StatefulWidget {
  const CodigoContrasenaPage({super.key});

  @override
  State<CodigoContrasenaPage> createState() => _CodigoContrasenaPageState();
}

class _CodigoContrasenaPageState extends State<CodigoContrasenaPage> {
  static const _validCode = '123456';
  static const _backgroundColor = Color(0xFFF6FAF8);
  static const _buttonColor = Color(0xFF34A0A4);
  static const _borderColor = Color(0xFFD9ED92);
  static const _focusColor = Color(0xFF168AAD);
  static const _textColor = Color(0xFF184E77);

  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _confirmCode() {
    final code = _controllers.map((controller) => controller.text).join();

    if (code == _validCode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NuevaContrasenaPage()),
      );
      return;
    }

    final message = code.length < _controllers.length
        ? 'Ingrese los 6 digitos del código'
        : 'Código incorrecto';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth < 360
                ? constraints.maxWidth - 24
                : 386.0;

            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: contentWidth,
                margin: const EdgeInsets.only(top: 1),
                padding: const EdgeInsets.fromLTRB(26, 24, 26, 26),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _borderColor),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F184E77),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ingresa el código de verificación enviado a tu\ncorreo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        _controllers.length,
                        (index) => _CodeDigitField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          borderColor: _borderColor,
                          focusColor: _focusColor,
                          onChanged: (value) => _onDigitChanged(value, index),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _buttonColor,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _confirmCode,
                        child: const Text(
                          'Confirmar registro',
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
            );
          },
        ),
      ),
    );
  }
}

class _CodeDigitField extends StatelessWidget {
  const _CodeDigitField({
    required this.controller,
    required this.focusNode,
    required this.borderColor,
    required this.focusColor,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Color borderColor;
  final Color focusColor;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: focusColor, width: 1.6),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
