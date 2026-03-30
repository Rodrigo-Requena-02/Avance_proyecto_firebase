import 'package:flutter/material.dart';
import 'dart:math';


void main() => runApp(const MiAplicacion());

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NumeroAleatorio(),
    );
  }
}

class NumeroAleatorio extends StatefulWidget {
  const NumeroAleatorio({super.key});

  @override
  State<NumeroAleatorio> createState() => _NumeroAleatorioState();
}

class _NumeroAleatorioState extends State<NumeroAleatorio> {
  int numero = 1;

  void numAleatorio() {
    setState(() {
      numero = Random().nextInt(100); 
    });
  }
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Número Aleatorio de 1 entre 100')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Numero: $numero',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            
            Row(
              // El row se hace para poder poner los botones uno al lado del otro
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: numAleatorio,
                  child: const Text('Iniciar'),
                ),
                const SizedBox(width: 10),
                
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
