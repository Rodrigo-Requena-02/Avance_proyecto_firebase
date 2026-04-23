
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'staff.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<Registro> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _cargando = false;

  void registrarUsuario() async {
    
    if (_passCtrl.text != _confirmPassCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Staff()));
      }
    } on FirebaseAuthException catch (e) {
      String mensaje = 'Error al registrar';
      if (e.code == 'weak-password') {
        mensaje = 'La contraseña debe tener al menos 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        mensaje = 'Este correo ya está registrado.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta Nueva')),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Correo electrónico', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Contraseña (mín. 6 caracteres)', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 20),
            TextField(controller: _confirmPassCtrl, decoration: const InputDecoration(labelText: 'Confirmar Contraseña', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 30),
            _cargando 
              ? const CircularProgressIndicator() 
              : ElevatedButton(
                  onPressed: registrarUsuario,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: const Text('Registrarme', style: TextStyle(fontSize: 16)),
                )
          ],
        ),
      ),
    );
  }
}