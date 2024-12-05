import '../models/doctor_model.dart';

class DoctorService {
  // Exemple de liste statique pour démarrer
  static List<Doctor> getDoctors() {
    return [
      Doctor(
        id: '1',
        name: 'Dr. Aissatou Diop',
        specialty: 'Cardiologie',
        location: 'Dakar',
        language: 'Français',
        experience: '10 ans',
        rating: 4.5,
        profilePicture: 'assets/images/doctor1.png',
      ),
      Doctor(
        id: '2',
        name: 'Dr. Mamadou Ndiaye',
        specialty: 'Dermatologie',
        location: 'Thiès',
        language: 'Anglais',
        experience: '7 ans',
        rating: 4.2,
        profilePicture: 'assets/images/doctor2.png',
      ),
    ];
  }
}
