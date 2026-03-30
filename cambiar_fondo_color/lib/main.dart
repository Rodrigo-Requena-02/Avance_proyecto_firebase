import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(const MiAplicacion());

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContadorSeg(),
    );
  }
}

class ContadorSeg extends StatefulWidget {
  const ContadorSeg({super.key});

  @override
  State<ContadorSeg> createState() => _ContadorSegState();
}

class _ContadorSegState extends State<ContadorSeg> {
  int segundos = 0;
  Timer? tiempo; // Se encarga de contar el tiempo real en segundo plano
  Color color = Colors.white;

  //Función iniciar
  void iniciar() {
    if (tiempo != null && tiempo!.isActive) return;
    // Esto evita que el contador vaya más rápido al presionar "iniciar" varias veces, es decir si la funcion Timer esta funcionando, este ignora el "toque"

    tiempo = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        segundos++;
      });
    });
  }

  //Función pausar
  void pausar() {
    tiempo?.cancel();// Se cancela la funcion Timer para que deje de sumar
  }

  //Función reiniciar
  void reiniciar() {
    tiempo?.cancel();
    setState(() {
      segundos = 0; // Se reinicia a 0 la variable segundos para que comienze de nuevo
    });
  }

  void colAleatorio() {
    setState(() {
      int numeroAleatoreo = Random().nextInt(Colors.primaries.length);
      color = Colors.primaries[numeroAleatoreo]; 
    });
  }
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(title: const Text('Contador de Segundos (CRONÓMETRO)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Segundos: $segundos',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            
            Row(
              // El row se hace para poder poner los botones uno al lado del otro
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: iniciar,
                  child: const Text('Iniciar'),
                ),
                const SizedBox(width: 10),
                
                ElevatedButton(
                  onPressed: pausar,
                  child: const Text('Pausar'),
                ),
                const SizedBox(width: 10),
                
                ElevatedButton(
                  onPressed: reiniciar,
                  child: const Text('Reiniciar'),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Cambiar el color de fondo:',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: colAleatorio,
                  child: const Text('Aleatorio'),
                ),
              ], 
            ),
          ],
        ),
      ),
    );
  }
}