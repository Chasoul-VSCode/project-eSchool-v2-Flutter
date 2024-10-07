import 'package:flutter/material.dart';

class GaleryScreen extends StatelessWidget {
  const GaleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[800],
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/200/200?random=$index',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
        },
        tooltip: 'Upload Image',
        // ignore: sort_child_properties_last
        child: const Icon(Icons.add_a_photo, color: Colors.white, size: 20),
        backgroundColor: Colors.blue,
      ),
    );
  }
}