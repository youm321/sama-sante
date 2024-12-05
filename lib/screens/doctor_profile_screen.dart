import 'package:flutter/material.dart';
import '../models/doctor_model.dart';

class DoctorProfileScreen extends StatelessWidget {
  final Doctor doctor;

  DoctorProfileScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(doctor.profilePicture),
              ),
            ),
            SizedBox(height: 16),
            Text('Spécialité : ${doctor.specialty}', style: TextStyle(fontSize: 18)),
            Text('Localisation : ${doctor.location}', style: TextStyle(fontSize: 18)),
            Text('Langue : ${doctor.language}', style: TextStyle(fontSize: 18)),
            Text('Expérience : ${doctor.experience}', style: TextStyle(fontSize: 18)),
            Text('Évaluation : ${doctor.rating} ★', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Ajouter la logique pour la consultation en ligne
              },
              child: Text('Programmer une consultation'),
            ),
          ],
        ),
      ),
    );
  }
}
