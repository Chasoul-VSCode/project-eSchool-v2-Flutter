import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),
              const SizedBox(height: 16),
              _buildDashboardGrid(),
              const SizedBox(height: 16),
              _buildCompletedTasksTable(),
              const SizedBox(height: 16),
              _buildPendingTasks(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: toggleTheme,
        tooltip: 'Toggle Theme',
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, size: 20),
        backgroundColor: isDarkMode ? Colors.amber : Colors.indigo,
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Add profile tap functionality here
              },
              child: Hero(
                tag: 'profileAvatar',
                child: CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/me.jpeg'),
                  radius: 30,
                  onBackgroundImageError: (exception, stackTrace) {
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chasoul UIX',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Teknik Informatika',
                    style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  Text(
                    'NPM : 12522028',
                    style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
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
      childAspectRatio: 1.1,
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
      elevation: 2,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 8,
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
      elevation: 2,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed Tasks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 8),
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
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 14,
          child: Icon(Icons.check, color: Colors.white, size: 16),
        ),
        title: Text(task, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Text(subject, style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
        trailing: Text(date, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 12)),
      ),
    );
  }

  Widget _buildPendingTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pending Tasks',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 8),
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
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: const Icon(Icons.assignment_late, color: Colors.orange, size: 20),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Text('Subject: $subject', style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}', style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
            Text('${dueDate.difference(DateTime.now()).inDays} days left',
                style: const TextStyle(color: Colors.red, fontSize: 10)),
          ],
        ),
        onTap: () {
          // Implement pending task item tap functionality
        },
      ),
    );
  }
}
