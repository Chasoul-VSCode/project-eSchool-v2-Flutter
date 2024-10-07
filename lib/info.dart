import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[900]!,
              Colors.grey[800]!,
              Colors.grey[700]!,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInfoSection('About Us', 'We are a leading educational institution committed to providing high-quality education and fostering academic excellence.', Icons.school),
            _buildInfoSection('Contact Information', 'Email: info@university.edu\nPhone: +1 (123) 456-7890\nAddress: 123 University Ave, City, State, ZIP', Icons.contact_mail),
            _buildInfoSection('Office Hours', 'Monday - Friday: 8:00 AM - 5:00 PM\nSaturday: 9:00 AM - 1:00 PM\nSunday: Closed', Icons.access_time),
            _buildInfoSection('Important Links', '• Student Portal\n• Library Resources\n• Career Services\n• Academic Calendar', Icons.link),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: const Color.fromARGB(255, 51, 98, 253), size: 24),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:const Color.fromARGB(255, 209, 209, 209)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}