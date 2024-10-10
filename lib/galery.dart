import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class GaleryScreen extends StatefulWidget {
  const GaleryScreen({super.key});

  @override
  GaleryScreenState createState() => GaleryScreenState();
}

class GaleryScreenState extends State<GaleryScreen> {
  List<dynamic> _data = [];
  bool _isLoading = true;
  File? _image;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://chasouluix.my.id/school_app/galery.php'));
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

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  Future<void> _uploadData() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title, description, and select an image')),
      );
      return;
    }

    final url = Uri.parse('https://chasouluix.my.id/school_app/galery.php');
    var request = http.MultipartRequest('POST', url);

    try {
      var fileStream = http.ByteStream(_image!.openRead());
      var fileLength = await _image!.length();

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        fileLength,
        filename: _image!.path.split('/').last,
      );

      request.files.add(multipartFile);

      request.fields['judul_galery'] = _titleController.text;
      request.fields['isi_galery'] = _descriptionController.text;
      request.fields['tgl_post_galery'] = DateTime.now().toIso8601String();
      request.fields['status_galery'] = '1';
      request.fields['kd_petugas'] = '1';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data uploaded successfully')),
          );
          _titleController.clear();
          _descriptionController.clear();
          setState(() {
            _image = null;
          });
          await _refreshData();
        } else {
          throw Exception('Upload failed: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to upload data: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading data: ${e.toString()}')),
      );
    }
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Data'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'Enter title'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(hintText: 'Enter description'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
                if (_image != null) Image.file(_image!, height: 100),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadData();
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadDialog,
        child: const Icon(Icons.add_photo_alternate),
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
                    child: Card(
                      color: Colors.grey[800],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              'https://chasouluix.my.id/school_app/${item['isi_galery']}',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[700],
                                  child: const Center(child: Icon(Icons.error)),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['judul_galery'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['isi_galery'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Posted: ${item['tgl_post_galery']?.toString() ?? ''}',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: item['status_galery'] == '1' ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        item['status_galery'] == '1' ? 'Active' : 'Inactive',
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
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
