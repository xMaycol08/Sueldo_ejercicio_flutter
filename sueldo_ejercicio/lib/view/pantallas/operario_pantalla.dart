import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/operario_viewmodel.dart';  
import '../widgets/campo_numero.dart';
import '../widgets/option_button.dart';

class OperarioPantalla extends StatefulWidget {
  @override
  State<OperarioPantalla> createState() => _OperarioPantallaState();
}

class _OperarioPantallaState extends State<OperarioPantalla> {
  //mapeo
  final sueldoController = TextEditingController();
  final antiguedadController = TextEditingController();
  //paso de parametros
  //rutas
  void calcular(){
    double sueldo = double.parse(sueldoController.text);
    int antiguedad = int.parse(antiguedadController.text);

    //recibir a view model
    final vm = context.read<OperarioViewModel>();
    final resultado = vm.calcular(sueldo, antiguedad);
    //paso de parametros
    Navigator.pushNamed(context, '/resultado', arguments: resultado);
  }

  @override
  Widget build(BuildContext context) {
  //para visualizar el view model en la pantalla
  final vm = context.watch<OperarioViewModel>();
  return Scaffold(
      appBar: AppBar(
        title: Text('Sueldo del Operador'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CampoNumero(
              etiqueta: 'Sueldo',
              controller: sueldoController,
            ),
            SizedBox(height: 16.0),
            CampoNumero(
              etiqueta: 'Antigüedad',
              controller: antiguedadController,
            ),
            SizedBox(height: 16.0),
            Text('Tipo Operario'),

            OptionButton(titulo: 'Operativo', 
            valor: 'Operativo',
            seleccionado: vm.tipoOperario,
            onChanged: (valor) => vm.SeleccionarTipoOperario(valor!),
            ),
            OptionButton(titulo: 'Administrativo', 
            valor: 'Administrativo',
            seleccionado: vm.tipoOperario,
            onChanged: (valor) => vm.SeleccionarTipoOperario(valor!),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: calcular,
              child: Text('Calcular'),
            ),
          ],
        ),
      )
  );
  }
}