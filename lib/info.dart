import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<dynamic> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://chasouluix.my.id/school_app/solev.php'));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData is List) {
          if (mounted) {
            setState(() {
              _data = decodedData;
              _isLoading = false;
            });
          }
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchData();
  }

  Future<void> _editInfo(Map<String, dynamic> item) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController =
            TextEditingController(text: item['judul_info']);
        final TextEditingController contentController =
            TextEditingController(text: item['isi_info']);
        return AlertDialog(
          title: const Text('Edit Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'judul_info': titleController.text,
                  'isi_info': contentController.text,
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      try {
        final response = await http.put(
          Uri.parse('https://chasouluix.my.id/school_app/solev.php'),
          body: json.encode({
            'kd_info': item['kd_info'],
            'judul_info': result['judul_info'],
            'isi_info': result['isi_info'],
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          _refreshData();
        } else {
          throw Exception('Failed to update info');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating info: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _deleteInfo(String kdInfo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this info?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final response = await http.delete(
          Uri.parse(
              'https://chasouluix.my.id/school_app/solev.php?kd_info=$kdInfo'),
        );

        if (response.statusCode == 200) {
          _refreshData();
        } else {
          throw Exception('Failed to delete info');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting info: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _addInfo() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController contentController = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'judul_info': titleController.text,
                  'isi_info': contentController.text,
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      try {
        final response = await http.post(
          Uri.parse('https://chasouluix.my.id/school_app/solev.php'),
          body: json.encode({
            'judul_info': result['judul_info'],
            'isi_info': result['isi_info'],
            'tgl_post_info': DateTime.now().toIso8601String(),
            'status_info': '1',
            'kd_petugas': '1', // Assuming a default value for kd_petugas
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['message'] == 'Data added successfully') {
            _refreshData();
          } else {
            throw Exception('Failed to add info: ${responseData['error']}');
          }
        } else {
          throw Exception('Failed to add info: ${response.statusCode}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding info: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      floatingActionButton: FloatingActionButton(
        onPressed: _addInfo,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final item = _data[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 2,
                            color: Colors.blue,
                            margin: const EdgeInsets.only(right: 16),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.grey[800],
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['judul_info'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.white,
                                                  size: 20),
                                              onPressed: () => _editInfo(item),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.white,
                                                  size: 20),
                                              onPressed: () =>
                                                  _deleteInfo(item['kd_info']),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['isi_info'] ?? '',
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['tgl_post_info']?.toString() ??
                                              '',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            _getStatusText(item['status_info']),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _getStatusText(String? status) {
    switch (status) {
      case '1':
        return 'Proses';
      case '2':
        return 'Selesai';
      case '0':
        return 'Dibatalkan';
      default:
        return status ?? '';
    }
  }
}
