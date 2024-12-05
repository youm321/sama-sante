import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _doctorCollection =
  FirebaseFirestore.instance.collection('doctors');

  Future<void> insertDoctorsData() async {
    final List<Map<String, dynamic>> doctors = [
      {
        "name": "Dr. John Doe",
        "address": "123 Main Street, Cityville",
        "available": "9:00 AM - 5:00 PM",
        "consultationFee": "50 USD",
        "createdAt": FieldValue.serverTimestamp(),
        "experienceYears": "10",
        "hospital": "City Hospital",
        "languagesSpoken": "English, French",
        "patientID": "P12345",
        "phone": "+1234567890",
        "rating": "4.8",
        "speciality": "Cardiology",
      },
      {
        "name": "Dr. Jane Smith",
        "address": "456 Elm Street, Townsville",
        "available": "8:00 AM - 3:00 PM",
        "consultationFee": "40 USD",
        "createdAt": FieldValue.serverTimestamp(),
        "experienceYears": "8",
        "hospital": "Townsville Medical Center",
        "languagesSpoken": "English, Spanish",
        "patientID": "P67890",
        "phone": "+9876543210",
        "rating": "4.5",
        "speciality": "Dermatology",
      },
      // Ajoutez d'autres médecins ici...
    ];

    try {
      for (var doctor in doctors) {
        await _doctorCollection.add(doctor);
      }
      print("Les données des médecins ont été insérées avec succès.");
    } catch (e) {
      print("Erreur lors de l'insertion des données : $e");
    }
  }
}
