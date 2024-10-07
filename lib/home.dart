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

  Future<void> _refreshData() async {
    // Simulate a data refresh
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // Update your data here if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildProfileCard(),
                  const SizedBox(height: 16),
                  _buildDashboardGrid(),
                  const SizedBox(height: 16),
                  _buildCompletedTasksTable(),
                  const SizedBox(height: 16),
                  _buildPendingTasks(),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: toggleTheme,
        tooltip: 'Toggle Theme',
        backgroundColor: isDarkMode ? Colors.amber : Colors.indigo,
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, size: 20),
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
                  const SizedBox(height: 4),
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
            Icons.book, 'Courses', Colors.blue, '5 Active', () {
          _showCoursesScreen(context);
        }),
        _buildComplexDashboardItem(
            Icons.assignment, 'Assignments', Colors.green, '3 Due', () {
          _showAssignmentsScreen(context);
        }),
        _buildComplexDashboardItem(Icons.calendar_today, 'Schedule',
            Colors.orange, 'Next: Math', () {
          _showScheduleScreen(context);
        }),
        _buildComplexDashboardItem(
            Icons.grade, 'Grades', Colors.red, 'GPA: 3.8', () {
          _showGradesScreen(context);
        }),
        _buildComplexDashboardItem(
            Icons.library_books, 'Library', Colors.purple, '2 Books', () {
          _showLibraryScreen(context);
        }),
        _buildComplexDashboardItem(
            Icons.people, 'Clubs', Colors.teal, '3 Joined', () {
          _showClubsScreen(context);
        }),
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

  void _showCoursesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Courses'),
            backgroundColor: Colors.blue,
          ),
          body: Container(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCourseItem('Mathematics', 'Prof. Smith', '09:00 AM - 10:30 AM'),
                _buildCourseItem('Physics', 'Dr. Johnson', '11:00 AM - 12:30 PM'),
                _buildCourseItem('Computer Science', 'Prof. Williams', '02:00 PM - 03:30 PM'),
                _buildCourseItem('English Literature', 'Dr. Brown', '04:00 PM - 05:30 PM'),
                _buildCourseItem('History', 'Prof. Davis', '06:00 PM - 07:30 PM'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseItem(String courseName, String instructor, String schedule) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(Icons.book, color: Colors.blue),
        title: Text(courseName, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(instructor, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
            Text(schedule, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  void _showAssignmentsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Assignments'),
            backgroundColor: Colors.green,
          ),
          body: Container(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildAssignmentItem('Math Problem Set', 'Mathematics', '05/25', 'Due'),
                _buildAssignmentItem('Physics Lab Report', 'Physics', '05/27', 'Due'),
                _buildAssignmentItem('English Essay', 'English Literature', '05/30', 'Due'),
                _buildAssignmentItem('History Research Paper', 'History', '06/05', 'Upcoming'),
                _buildAssignmentItem('Programming Project', 'Computer Science', '06/10', 'Upcoming'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentItem(String title, String subject, String dueDate, String status) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(Icons.assignment, color: status == 'Due' ? Colors.red : Colors.green),
        title: Text(title, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Text(subject, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(dueDate, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
            Text(status, style: TextStyle(color: status == 'Due' ? Colors.red : Colors.green)),
          ],
        ),
      ),
    );
  }

  void _showScheduleScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Schedule'),
            backgroundColor: Colors.orange,
          ),
          body: Container(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildScheduleItem('Mathematics', '09:00 AM - 10:30 AM', 'Room 101'),
                _buildScheduleItem('Physics', '11:00 AM - 12:30 PM', 'Lab 2'),
                _buildScheduleItem('Lunch Break', '12:30 PM - 02:00 PM', 'Cafeteria'),
                _buildScheduleItem('Computer Science', '02:00 PM - 03:30 PM', 'Computer Lab'),
                _buildScheduleItem('English Literature', '04:00 PM - 05:30 PM', 'Room 205'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String subject, String time, String location) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(Icons.schedule, color: Colors.orange),
        title: Text(subject, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Text(location, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
        trailing: Text(time, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
      ),
    );
  }

  void _showGradesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Grades'),
            backgroundColor: Colors.red,
          ),
          body: Container(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildGradeItem('Mathematics', 'A', '95%'),
                _buildGradeItem('Physics', 'A-', '92%'),
                _buildGradeItem('Computer Science', 'A+', '98%'),
                _buildGradeItem('English Literature', 'B+', '88%'),
                _buildGradeItem('History', 'A-', '91%'),
                Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  margin: const EdgeInsets.only(top: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Current GPA: 3.8',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradeItem(String subject, String grade, String percentage) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(Icons.grade, color: Colors.red),
        title: Text(subject, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(grade, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
            Text(percentage, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  void _showLibraryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Library'),
            backgroundColor: Colors.purple,
          ),
          body: Container(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildLibraryItem('Introduction to Algorithms', 'Thomas H. Cormen', '06/05'),
                _buildLibraryItem('To Kill a Mockingbird', 'Harper Lee', '06/10'),
                Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  margin: const EdgeInsets.only(top: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Books Borrowed: 2',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryItem(String title, String author, String dueDate) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(Icons.book, color: Colors.purple),
        title: Text(title, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Text(author, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Due:', style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
            Text(dueDate, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }

  void _showClubsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Clubs'),
            backgroundColor: Colors.teal,
          ),
          body: Container(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildClubItem('Coding Club', 'Tuesdays, 4:00 PM', 'Computer Lab'),
                _buildClubItem('Debate Society', 'Wednesdays, 5:00 PM', 'Auditorium'),
                _buildClubItem('Chess Club', 'Thursdays, 3:30 PM', 'Room 103'),
                Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  margin: const EdgeInsets.only(top: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Joined Clubs: 3',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClubItem(String clubName, String meetingTime, String location) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(Icons.group, color: Colors.teal),
        title: Text(clubName, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Text(location, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
        trailing: Text(meetingTime, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
