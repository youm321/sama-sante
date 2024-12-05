import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String doctorId;
  final String userID;

  AppointmentScreen({
    required this.doctorName,
    required this.doctorId,
    required this.userID,
  });

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm');

  late Future<List<Map<String, dynamic>>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _fetchAppointments();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = _dateFormat.format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = _timeFormat.format(
          DateTime(0, 0, 0, picked.hour, picked.minute),
        );
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (_dateController.text.isEmpty || _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une date et une heure')),
      );
      return;
    }

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('appointments')
          .where('userID', isEqualTo: widget.userID)
          .where('date', isEqualTo: _dateController.text)
          .where('time', isEqualTo: _timeController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous avez déjà un rendez-vous à cet horaire.')),
        );
        return;
      }

      await _firestore.collection('appointments').add({
        'doctorName': widget.doctorName,
        'doctorId': widget.doctorId,
        'userID': widget.userID,
        'date': _dateController.text,
        'time': _timeController.text,
        'confirmed': false,
      });

      setState(() {
        _appointments = _fetchAppointments();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rendez-vous réservé avec succès !')),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Erreur lors de la réservation : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la réservation.')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAppointments() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('userID', isEqualTo: widget.userID)
          .orderBy('date')
          .orderBy('time')
          .get();

      List<Map<String, dynamic>> appointments =
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      return appointments;
    } catch (e) {
      debugPrint('Erreur lors de la récupération des rendez-vous : $e');
      return [];
    }
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    String date = appointment['date'];
    String time = appointment['time'];
    bool confirmed = appointment['confirmed'] ?? false;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text('Date : $date\nHeure : $time'),
        subtitle: Text(
          confirmed ? 'Statut : Confirmé' : 'Statut : Non confirmé',
          style: TextStyle(
            color: confirmed ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          confirmed ? Icons.check_circle : Icons.cancel,
          color: confirmed ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _appointments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur lors du chargement des rendez-vous'));
        }

        var appointments = snapshot.data ?? [];
        if (appointments.isEmpty) {
          return Center(
            child: Text(
              'Aucun rendez-vous disponible',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: appointments.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildAppointmentCard(appointments[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prendre rendez-vous'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Planifiez un rendez-vous avec ${widget.doctorName}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dateController.text.isEmpty
                            ? "Choisissez une date"
                            : _dateController.text,
                        style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
                      ),
                      Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _timeController.text.isEmpty
                            ? "Choisissez une heure"
                            : _timeController.text,
                        style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
                      ),
                      Icon(Icons.access_time, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Confirmer le RDV',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Vos rendez-vous :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildAppointmentsList(),
            ],
          ),
        ),
      ),
    );
  }
}
