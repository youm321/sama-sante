import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String availability;
  final VoidCallback onTap;

  const DoctorCard({
    required this.doctorName,
    required this.specialty,
    required this.availability,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(doctorName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$specialty\nDisponibilité : $availability'),
        isThreeLine: true,
        trailing: ElevatedButton(
          onPressed: onTap,
          child: Text('Prendre RDV'),
        ),
      ),
    );
  }
}
