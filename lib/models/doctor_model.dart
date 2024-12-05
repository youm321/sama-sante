class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String location;
  final String language;
  final String experience;
  final double rating;
  final String profilePicture;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.language,
    required this.experience,
    required this.rating,
    required this.profilePicture,
  });

  // Exemple pour récupérer un médecin depuis une base de données JSON ou Firebase
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      name: map['name'],
      specialty: map['specialty'],
      location: map['location'],
      language: map['language'],
      experience: map['experience'],
      rating: map['rating']?.toDouble() ?? 0.0,
      profilePicture: map['profilePicture'],
    );
  }
}
