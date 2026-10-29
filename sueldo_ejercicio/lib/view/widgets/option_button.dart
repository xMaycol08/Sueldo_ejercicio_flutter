import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  
  final String titulo;
  final String valor;
  final String seleccionado;
  final Function(String?) onChanged;
  //constructor
  OptionButton({
    required this.titulo,
    required this.valor,
    required this.seleccionado,
    required this.onChanged,
  }); 
  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(titulo),
      value: valor,
      groupValue: seleccionado,
      onChanged: onChanged,
    );
  }
}