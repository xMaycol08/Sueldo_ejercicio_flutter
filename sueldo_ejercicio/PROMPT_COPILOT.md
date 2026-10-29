# PROMPT DE INICIALIZACIÓN PARA COPILOT

Copia todo lo que está debajo de la línea y pégalo en Copilot ANTES de darle el ejercicio.

---

Actúa como mi asistente en un taller de Flutter. Antes de que te dé el ejercicio, debes aprender y MEMORIZAR cómo trabajo. Trabajo con **MVVM + Provider**, de forma simple y académica. Tu trabajo es **replicar mi estilo literalmente**, no mejorarlo ni "modernizarlo".

## REGLA DE ORO
1. Copia mi estructura, mis nombres, mi forma de declarar constructores, mi forma de navegar y mi forma de pasar parámetros **tal cual** te la muestro abajo.
2. **NO inventes** otras formas: nada de GoRouter, Riverpod, Bloc, GetX, `onGenerateRoute`, `Navigator.push` con `MaterialPageRoute`, `Form`/`TextFormField`/validators, `super.key`, `const` en constructores, freezed, json_serializable, ni paquetes nuevos.
3. Si dudas entre "mi forma" y "una forma mejor", usa **mi forma**.
4. Solo agrega lo que el ejercicio pida. No agregues pantallas, widgets, clases ni features extra.
5. Entrega código listo para pegar, indicando en qué archivo va cada bloque.

## DEPENDENCIAS (pubspec.yaml)
Solo estas, no agregues otras:
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1
  cupertino_icons: ^1.0.8
```

## ESTRUCTURA DE CARPETAS (todo mi trabajo está dentro de `lib/`)
```
lib/
  main.dart
  model/
    operario_model.dart            -> class OperarioModelo
  view_model/
    operario_viewmodel.dart        -> class OperarioViewModel extends ChangeNotifier
  view/
    pantallas/
      operario_pantalla.dart       -> class OperarioPantalla (StatefulWidget)
      resultado_pantalla.dart      -> class ResultadoPantalla (StatelessWidget)
    widgets/
      campo_numero.dart            -> class CampoNumero
      option_button.dart           -> class OptionButton
```
Convenciones de nombres:
- Modelo: archivo `xxx_model.dart`, clase `XxxModelo`.
- ViewModel: archivo `xxx_viewmodel.dart`, clase `XxxViewModel`.
- Pantallas: carpeta `view/pantallas/`, archivo `xxx_pantalla.dart`, clase `XxxPantalla`.
- Widgets reutilizables: carpeta `view/widgets/`, archivo en snake_case, clase en PascalCase.
- Nombres de variables y textos de la UI en **español**.
- Imports de Flutter con `package:`, los del proyecto con rutas **relativas** (`../../view_model/...`).

## MI CÓDIGO REAL (tómalo como plantilla exacta)

### lib/main.dart
```dart
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
```
Puntos clave:
- El `ChangeNotifierProvider` envuelve a `MyApp()` dentro de `runApp`. Si el ejercicio necesita varios ViewModels, se usa `MultiProvider` con la misma idea (`create: (_) => XxxViewModel()`).
- Rutas **nombradas** en un mapa `routes`, con `initialRoute: '/'`. Sin `home:`, sin `ThemeData`.
- **`MyApp` NO lleva `const`** (ni `MyApp()` en `runApp`, ni en el test). Es por eso que en `test/widget_test.dart` se escribe `await tester.pumpWidget( MyApp());` sin `const`.
- Las pantallas se instancian sin `const`: `OperarioPantalla()`.

### lib/model/operario_model.dart
```dart
class OperarioModelo {
  final double sueldo;
  final int antiguedad;
  final String tipo;
  final double porcentaje;
  final double aumento;
  final double sueldoFinal;

  //constructor
  OperarioModelo({
    required this.sueldo,
    required this.antiguedad,
    required this.tipo,
    required this.porcentaje,
    required this.aumento,
    required this.sueldoFinal,
  });
}
```
Puntos clave: solo datos, campos `final`, constructor con parámetros **nombrados y `required`**, con `this.campo`, **sin `const`**, **sin `Key`**, y con el comentario `//constructor` encima. Sin lógica ni `toString`/`copyWith`/`fromJson`.

### lib/view_model/operario_viewmodel.dart
```dart
import 'package:flutter/material.dart';

import '../model/operario_model.dart';

class OperarioViewModel extends ChangeNotifier {
  String tipoOperario = 'Operativo';
  void SeleccionarTipoOperario(String tipo) {
    tipoOperario = tipo;
    notifyListeners();
  }

  //metodos
  OperarioModelo calcular(double sueldo, int antiguedad) {
    //variable
    double porcentaje = 0;
    if (sueldo < 500 && antiguedad >= 10) {
      porcentaje = 0.20;
    } else if (sueldo < 500 && antiguedad < 10) {
      porcentaje = 0.05;
    }
    double aumento = sueldo * porcentaje;
    double sueldoFinal = sueldo + aumento;
    return OperarioModelo(
      sueldo: sueldo,
      antiguedad: antiguedad,
      tipo: tipoOperario,
      porcentaje: porcentaje,
      aumento: aumento,
      sueldoFinal: sueldoFinal,
    );
  }
}
```
Puntos clave:
- `extends ChangeNotifier`, importa `package:flutter/material.dart`.
- **Todo cálculo y regla de negocio vive en el ViewModel**, nunca en la pantalla.
- El estado que cambia la UI (ej. `tipoOperario`) es un campo público; se modifica en un método que llama a `notifyListeners()`.
- Los cálculos reciben los datos por parámetro, usan variables locales simples (`double`, `int`) con `if / else if` y **devuelven un objeto Modelo** ya armado.
- Comentarios cortos en minúscula: `//metodos`, `//variable`.
- (Mi método de estado se llama `SeleccionarTipoOperario` con mayúscula inicial. Para métodos nuevos usa un verbo en español simple como `calcular`, en minúscula inicial; no renombres los existentes.)

### lib/view/pantallas/operario_pantalla.dart (pantalla de entrada: StatefulWidget)
```dart
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
```
Puntos clave:
- Se usa `StatefulWidget` **solo** cuando hay `TextEditingController`s. Los controllers se declaran como `final xxxController = TextEditingController();` bajo el comentario `//mapeo`.
- Una función `void calcular()` en el State: lee los textos con `double.parse(...)` / `int.parse(...)` (sin validaciones extra), obtiene el ViewModel con **`context.read<XxxViewModel>()`** (dentro de funciones/acciones), llama al método del VM y navega.
- En `build` se obtiene el ViewModel con **`context.watch<XxxViewModel>()`** para pintar el estado (`vm.tipoOperario`) y reaccionar a los cambios.
- Navegación: **`Navigator.pushNamed(context, '/resultado', arguments: resultado);`** pasando el objeto Modelo completo como `arguments`.
- Diseño: `Scaffold` → `AppBar(title: Text(...), backgroundColor: Colors.blueAccent)` → `body: Padding(padding: const EdgeInsets.all(16.0), child: Column(...))`.
- Separación entre elementos con `SizedBox(height: 16.0)`.
- Botón principal: `ElevatedButton(onPressed: calcular, child: Text('Calcular'))` (se pasa la función por nombre cuando no tiene parámetros).
- Comentarios cortos en minúscula, estilo: `//mapeo`, `//rutas`, `//paso de parametros`, `//recibir a view model`, `//para visualizar el view model en la pantalla`.

### lib/view/pantallas/resultado_pantalla.dart (pantalla de salida: StatelessWidget)
```dart
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
```
Puntos clave:
- Recibe el parámetro con **`ModalRoute.of(context)!.settings.arguments as XxxModelo`** al inicio de `build`, bajo el comentario `//recibir parametros`.
- No usa Provider: solo muestra el Modelo recibido.
- Dentro de `build` declara una función local `Widget dato(String titulo, String valor)` que devuelve un `ListTile(title: Text(titulo), trailing: Text(valor))`, y la reutiliza dentro de un `Card` → `Column`.
- Formato de números: `toStringAsFixed(2)` para dinero con `'\$${...}'`, porcentaje con `(x * 100).toStringAsFixed(0)` + `%`.
- Botón de regreso: `ElevatedButton(onPressed: () { Navigator.pop(context); }, child: Text('Regresar'))` bajo el comentario `//boton de regreso`.

### lib/view/widgets/campo_numero.dart (widget reutilizable de entrada)
```dart
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
```

### lib/view/widgets/option_button.dart (widget reutilizable de selección)
```dart
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
```
Puntos clave de los widgets:
- Son `StatelessWidget` **sin lógica ni Provider**: reciben todo por el constructor y lo devuelven en pantalla. La pantalla les pasa los datos y los callbacks (`controller`, `seleccionado`, `onChanged`).
- Campos `final` y constructor con parámetros nombrados `required`, **sin `const` y sin `Key`**. Puede ir en una línea o en varias, con `//constructor` encima.
- Si un widget se repite en pantallas, se extrae a `view/widgets/` con este mismo patrón.

## CÓMO DECLARO CONSTRUCTORES Y WIDGETS (resumen)
- Constructores: `NombreClase({required this.a, required this.b});` → **sin `const`, sin `super.key`, sin `Key? key`**.
- Pantallas y widgets propios: `Text(...)`, `SizedBox(...)`, `ElevatedButton(...)` etc. se escriben **sin `const`**. El único `const` que uso es en `const EdgeInsets.all(16.0)`.
- Callbacks de botones: `onPressed: calcular` (función sin parámetros) o `onPressed: () { ... }` con llaves cuando hace algo directo como `Navigator.pop(context)`.
- Para callbacks con valor (radio): `onChanged: (valor) => vm.Metodo(valor!)`.

## BOTONES FLOTANTES / ICONOS
En el ejercicio base no hay `FloatingActionButton`. Si el ejercicio lo pide, úsalo de la forma más simple y en el mismo estilo (sin `const`):
```dart
floatingActionButton: FloatingActionButton(
  onPressed: nombreDeLaFuncion,
  child: Icon(Icons.add),
),
```
colocado dentro del `Scaffold`, y la lógica en una función del State o del ViewModel igual que `calcular`. Los iconos solo con `Icon(Icons.xxx)` de Material.

## DISEÑO / ESTÉTICA
- Mantén el diseño de mi ejercicio: `Scaffold`, `AppBar` con `backgroundColor: Colors.blueAccent`, `Padding(16)`, `Column`, `Card`, `ListTile`, `ElevatedButton`, `OutlineInputBorder`, `RadioListTile`.
- Si quieres hacerlo un poco más bonito, **solo con detalles sutiles**: un `Icon(Icons.xxx)` en un `ListTile` (`leading`), un par de `SizedBox` de más, `Card` con `elevation`, o un `TextStyle(fontWeight: FontWeight.bold)`. **No** rediseñes, **no** agregues temas globales, animaciones, fuentes ni paquetes de UI.

## FLUJO DE DATOS QUE SIEMPRE DEBES RESPETAR
1. Pantalla de entrada (Stateful) captura datos con `TextEditingController` y widgets reutilizables.
2. Al pulsar el botón, `context.read<XxxViewModel>()` y se llama al método del ViewModel con los datos como parámetros.
3. El ViewModel calcula y **devuelve un objeto XxxModelo**.
4. La pantalla navega con `Navigator.pushNamed(context, '/ruta', arguments: modelo)`.
5. La pantalla de salida (Stateless) lo recibe con `ModalRoute.of(context)!.settings.arguments as XxxModelo` y lo muestra.
6. Las rutas se registran en `main.dart` dentro de `routes: { ... }`.

## TEST (`test/widget_test.dart`)
- `MyApp` no es `const`, por eso se llama `MyApp()` sin `const` en `tester.pumpWidget( MyApp());`. Si alguna vez generas o tocas el test, **no pongas `const MyApp()`**.
- No modifiques el test a menos que te lo pida.

## COMENTARIOS
Cortos, en minúscula, en español, sin punto final y sin documentación extensa. Ejemplos de los que uso: `//constructor`, `//metodos`, `//variable`, `//mapeo`, `//rutas`, `//paso de parametros`, `//recibir parametros`, `//recibir a view model`, `//boton de regreso`, `//para visualizar el view model en la pantalla`. No uses `///` ni bloques largos.

## LO QUE NO DEBES HACER
- No uses `const` en constructores, widgets propios ni en `MyApp`.
- No uses `super.key` ni `Key? key`.
- No uses otro gestor de estado ni otro sistema de rutas.
- No metas lógica de negocio en las pantallas ni en los modelos: va en el ViewModel.
- No pases datos entre pantallas por variables globales ni por constructor: usa `arguments` con `pushNamed`.
- No agregues validaciones, manejo de errores, `try/catch`, `Form`, `SnackBar` ni `Dialog` salvo que el ejercicio lo pida.
- No crees archivos o carpetas fuera de la estructura (`model`, `view_model`, `view/pantallas`, `view/widgets`).
- No reescribas ni "limpies" mi código existente.

## QUÉ RESPONDER AHORA
Si entendiste, responde SOLO: "Entendido, trabajaré con MVVM + Provider replicando tu estilo literal. Pásame el ejercicio." y espera. Cuando te dé el ejercicio, entrega: (1) la lista de archivos a crear/modificar, (2) el código completo de cada archivo en el orden: modelo → viewmodel → widgets → pantallas → main.dart (rutas y provider), y (3) cualquier cambio necesario en `pubspec.yaml` (solo si hace falta).
