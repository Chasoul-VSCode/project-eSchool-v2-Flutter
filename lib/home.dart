import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildDashboardGrid(),
              const SizedBox(height: 20),
              _buildCompletedTasksTable(),
              const SizedBox(height: 20),
              _buildPendingTasks(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement quick action functionality
        },
        tooltip: 'Quick Actions',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Add profile tap functionality here
              },
              child: Hero(
                tag: 'profileAvatar',
                child: CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/me.jpeg'),
                  radius: 50,
                  onBackgroundImageError: (exception, stackTrace) {
                  },
                ),
              ),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chasoul UIX',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Teknik Informatika',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    'NPM : 12522028',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildComplexDashboardItem(
            Icons.book, 'Courses', Colors.blue, '5 Active', () {}),
        _buildComplexDashboardItem(
            Icons.assignment, 'Assignments', Colors.green, '3 Due', () {}),
        _buildComplexDashboardItem(Icons.calendar_today, 'Schedule',
            Colors.orange, 'Next: Math', () {}),
        _buildComplexDashboardItem(
            Icons.grade, 'Grades', Colors.red, 'GPA: 3.8', () {}),
        _buildComplexDashboardItem(
            Icons.library_books, 'Library', Colors.purple, '2 Books', () {}),
        _buildComplexDashboardItem(
            Icons.people, 'Clubs', Colors.teal, '3 Joined', () {}),
      ],
    );
  }

  Widget _buildComplexDashboardItem(IconData icon, String title, Color color,
      String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: Colors.white),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedTasksTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Completed Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildTaskItem('Essay', 'English', '2023-05-15'),
                _buildTaskItem('Quiz', 'Math', '2023-05-18'),
                _buildTaskItem('Project', 'Science', '2023-05-20'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String task, String subject, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.check, color: Colors.white),
        ),
        title: Text(task, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subject),
        trailing: Text(date, style: TextStyle(color: Colors.grey.shade600)),
      ),
    );
  }

  Widget _buildPendingTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pending Tasks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildPendingTaskItem('Research Paper', 'History',
            DateTime.now().add(const Duration(days: 7))),
        _buildPendingTaskItem('Group Presentation', 'Business',
            DateTime.now().add(const Duration(days: 5))),
        _buildPendingTaskItem('Lab Report', 'Chemistry',
            DateTime.now().add(const Duration(days: 3))),
      ],
    );
  }

  Widget _buildPendingTaskItem(String title, String subject, DateTime dueDate) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.assignment_late, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Subject: $subject'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}'),
            Text('${dueDate.difference(DateTime.now()).inDays} days left',
                style: const TextStyle(color: Colors.red)),
          ],
        ),
        onTap: () {
          // Implement pending task item tap functionality
        },
      ),
    );
  }
}
