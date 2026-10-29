import 'package:flutter/material.dart';

import '../../model/operario_model.dart';

class ResultadoPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //recibir parametros
    final operario =
        ModalRoute.of(context)!.settings.arguments as OperarioModelo;
    Widget dato(String titulo, String valor) {
      return ListTile(title: Text(titulo), trailing: Text(valor));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  dato('Tipo', operario.tipo),
                  dato('Sueldo', '\$${operario.sueldo.toStringAsFixed(2)}'),
                  dato('Antiguedad', '${operario.antiguedad} años'),
                  dato('Aumento','${(operario.porcentaje * 100).toStringAsFixed(0)}%',),
                  dato('Valor Aumentado','\$${operario.aumento.toStringAsFixed(2)}',),
                  dato('Sueldo Final','\$${operario.sueldoFinal.toStringAsFixed(2)}',),
                ],
              ),
            ),
            //boton de regreso
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
