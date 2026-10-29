// CampoNumero

import 'package:flutter/material.dart';

class CampoNumero extends StatelessWidget {
  final String etiqueta;
  final TextEditingController controller;

  CampoNumero({required this.etiqueta, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: OutlineInputBorder(),
      ),
    );
  }
}