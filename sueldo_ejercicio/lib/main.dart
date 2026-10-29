import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model/operario_viewmodel.dart';
import 'view/pantallas/operario_pantalla.dart';
import 'view/pantallas/resultado_pantalla.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => OperarioViewModel(),
    child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => OperarioPantalla(),
        '/resultado': (context) => ResultadoPantalla(),
      },
    );
  }
}