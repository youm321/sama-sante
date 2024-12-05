import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDoctorForm extends StatefulWidget {
  @override
  _AddDoctorFormState createState() => _AddDoctorFormState();
}

class _AddDoctorFormState extends State<AddDoctorForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  // Champs du formulaire
  String? name;
  String? speciality;
  String? phone;
  String? languagesSpoken;
  String? hospital;
  String? address;
  String? consultationFee;
  String? experienceYears;
  String? available;
  String? rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un Médecin"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nom"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le nom du médecin.";
                  }
                  return null;
                },
                onSaved: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Spécialité"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer la spécialité.";
                  }
                  return null;
                },
                onSaved: (value) => speciality = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Téléphone"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un numéro de téléphone.";
                  }
                  return null;
                },
                onSaved: (value) => phone = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Langues parlées"),
                onSaved: (value) => languagesSpoken = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Hôpital"),
                onSaved: (value) => hospital = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Adresse"),
                onSaved: (value) => address = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Frais de consultation"),
                keyboardType: TextInputType.number,
                onSaved: (value) => consultationFee = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Années d'expérience"),
                keyboardType: TextInputType.number,
                onSaved: (value) => experienceYears = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Disponible (Oui/Non)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez indiquer la disponibilité.";
                  }
                  return null;
                },
                onSaved: (value) => available = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Évaluation"),
                keyboardType: TextInputType.number,
                onSaved: (value) => rating = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Ajouter le Médecin"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour valider et soumettre le formulaire
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Ajout d'un document avec Firestore
        DocumentReference docRef = await _firestore.collection('doctors').add({
          'name': name,
          'speciality': speciality,
          'phone': phone,
          'languagesSpoken': languagesSpoken,
          'hospital': hospital,
          'address': address,
          'consultationFee': consultationFee,
          'experienceYears': experienceYears,
          'available': available,
          'rating': rating,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Mise à jour du champ patientID avec l'ID généré
        await docRef.update({'patientID': docRef.id});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Médecin ajouté avec succès !")),
        );

        // Réinitialiser le formulaire après l'ajout
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'ajout : $e")),
        );
      }
    }
  }
}