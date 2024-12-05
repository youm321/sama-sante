import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ajout de l'import pour FirebaseAuth
import 'appointment_screen.dart';
import '../widgets/doctor_card.dart';

class OnlineConsultationScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultation en ligne'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun médecin disponible.'));
          }

          final doctors = snapshot.data!.docs;

          // Récupérer l'ID de l'utilisateur connecté
          final userID = FirebaseAuth.instance.currentUser?.uid;

          if (userID == null) {
            return Center(child: Text('Utilisateur non connecté.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              final doctorName = doctor['name'] ?? 'Nom non disponible';
              final specialty = doctor['speciality'] ?? 'Spécialité non spécifiée';
              final availability = doctor['available'] ?? 'Disponibilité inconnue';

              return DoctorCard(
                doctorName: doctorName,
                specialty: specialty,
                availability: availability,
                onTap: () {
                  if (availability.toLowerCase() != 'oui') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$doctorName n\'est pas disponible actuellement.')),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentScreen(
                          doctorName: doctorName,
                          doctorId: doctor.id, // Utilisation de l'ID du document Firestore
                          userID: userID, // ID dynamique de l'utilisateur
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
