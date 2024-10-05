import 'package:flutter/material.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          _buildAgendaItem('Meeting with Professor', 'Monday, 10:00 AM', Icons.person),
          _buildAgendaItem('Submit Assignment', 'Tuesday, 11:59 PM', Icons.assignment),
          _buildAgendaItem('Group Study Session', 'Wednesday, 3:00 PM', Icons.group),
          _buildAgendaItem('Lab Work', 'Thursday, 2:00 PM', Icons.science),
          _buildAgendaItem('Career Fair', 'Friday, 9:00 AM - 4:00 PM', Icons.work),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        tooltip: 'Add new agenda item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAgendaItem(String title, String time, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
        },
      ),
    );
  }
}