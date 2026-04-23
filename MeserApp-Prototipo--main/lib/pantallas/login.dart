import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'staff.dart';
import 'registro.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();

}

class LoginState extends State<Login> {
  final _emailCtrl = TextEditingController(); 
  final _passCtrl = TextEditingController();
  
  bool _cargando = false; 

  void intentarLogin() async {
    setState(() {
      _cargando = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Staff()));
      }

    } on FirebaseAuthException catch (e) {
      String mensaje = 'Error al iniciar sesión';
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        mensaje = 'Correo o contraseña incorrectos.';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }
void iniciarConGoogle() async {
    setState(() => _cargando = true);
    try {

      await GoogleSignIn.instance.initialize(
        serverClientId: '776509224127-peb5aa78l6bok521q3l8f29csiiv94b5.apps.googleusercontent.com',
      );
      

      final GoogleSignInAccount? usuarioGoogle = await GoogleSignIn.instance.authenticate();
      
      if (usuarioGoogle != null) {

        final GoogleSignInAuthentication authGoogle = await usuarioGoogle.authentication;
        

        final credential = GoogleAuthProvider.credential( 
          idToken: authGoogle.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Staff()));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al iniciar con Google'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acceso Empleados')),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Correo electrónico', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            
            _cargando 
              ? const CircularProgressIndicator() 
              : ElevatedButton(
                  onPressed: intentarLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 16)),
                ),

                const Divider(height: 40), 
                OutlinedButton.icon(
                  label: const Text('Continuar con Google'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: iniciarConGoogle,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const Registro()));
                  },
                  child: const Text('¿No tienes cuenta? Regístrate aquí'),
                )

          ],
        ),
      ),
    );
  }
}