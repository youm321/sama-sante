import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register_screen.dart';
import 'home_screen.dart'; // Assurez-vous d'importer votre page HomeScreen
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  void _loginUser() async {
    setState(() {
      _isLoading = true; // Afficher le loader
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Authentification via Firebase
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connexion réussie")),
      );

      // Redirection vers la page HomeScreen après la connexion
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()), // Redirige vers HomeScreen
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Une erreur s'est produite";
      if (e.code == 'user-not-found') {
        errorMessage = "Aucun utilisateur trouvé pour cet email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Mot de passe incorrect.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur inattendue : $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Cacher le loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond vert clair
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Se connecter',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(16), // Angles arrondis
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CustomInputField(

                        controller: _emailController,
                        label: 'Email',
                        hintText: 'Entrez votre email',

                        keyboardType: TextInputType.emailAddress,

                      ),
                      SizedBox(height: 16),
                      CustomInputField(
                        controller: _passwordController,
                        label: 'Mot de passe',
                        hintText: 'Entrez votre mot de passe',
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      _isLoading
                          ? CircularProgressIndicator()
                          : CustomButton(

                        text: 'Se connecter',

                        onPressed: _loginUser, // Appel de la logique de connexion
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    "Créer un compte",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
