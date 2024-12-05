import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _profilePictureController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Si l'utilisateur est déjà connecté, on peut remplir certains champs
    _getUserProfile();
  }

  // Fonction pour récupérer les informations de l'utilisateur si elles existent déjà dans Firestore
  void _getUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _emailController.text = userDoc['email'] ?? '';
          _nameController.text = userDoc['name'] ?? '';
          _phoneNumberController.text = userDoc['phoneNumber'] ?? '';
          _profilePictureController.text = userDoc['profilePicture'] ?? '';
          _roleController.text = userDoc['role'] ?? '';
        });
      }
    }
  }

  // Fonction pour enregistrer ou mettre à jour le profil de l'utilisateur
  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // On crée un document dans Firestore avec l'ID de l'utilisateur
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'createdAt': FieldValue.serverTimestamp(), // Timestamp de création
          'email': _emailController.text,
          'name': _nameController.text,
          'phoneNumber': _phoneNumberController.text,
          'profilePicture': _profilePictureController.text,
          'role': _roleController.text,
          'userID': user.uid,  // L'ID de l'utilisateur
        }, SetOptions(merge: true));  // 'merge: true' pour éviter d'écraser les données existantes

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profil mis à jour !')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Profil'),
        backgroundColor: Colors.blueAccent, // Couleur bleue pour la barre d'applications
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.blue), // Couleur du texte du label
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              // Champ Nom
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              // Champ Numéro de téléphone
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              // Champ URL de la photo de profil
              TextFormField(
                controller: _profilePictureController,
                decoration: InputDecoration(
                  labelText: 'URL de la photo de profil',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'URL de la photo de profil';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              // Champ Rôle
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(
                  labelText: 'Rôle',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un rôle';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Bouton Confirmer
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Confirmer'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Couleur bleue pour le bouton
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bord arrondi pour un look moderne
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
