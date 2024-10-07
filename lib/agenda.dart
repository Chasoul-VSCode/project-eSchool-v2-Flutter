import 'package:flutter/material.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildAgendaItem('Meeting with Professor', 'Monday, 10:00 AM', Icons.person),
          _buildAgendaItem('Submit Assignment', 'Tuesday, 11:59 PM', Icons.assignment),
          _buildAgendaItem('Group Study Session', 'Wednesday, 3:00 PM', Icons.group),
          _buildAgendaItem('Lab Work', 'Thursday, 2:00 PM', Icons.science),
          _buildAgendaItem('Career Fair', 'Friday, 9:00 AM - 4:00 PM', Icons.work),
        ],
      ),
    );
  }

  Widget _buildAgendaItem(String title, String time, IconData icon) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(icon, color: const Color.fromARGB(255, 26, 126, 240), size: 20),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        subtitle: Text(
          time,
          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
        onTap: () {
        },
      ),
    );
  }
}