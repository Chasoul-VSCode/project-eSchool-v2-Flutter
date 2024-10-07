import 'package:flutter/material.dart';
import 'home.dart';
import 'info.dart';
import 'agenda.dart';
import 'galery.dart';
import 'login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const InfoScreen(),
    const AgendaScreen(),
    const GaleryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, size: 20),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          'Chasoul UIX',
          style: TextStyle(
            color: Color.fromARGB(255, 246, 246, 248),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.blueAccent, Colors.indigo],
            ),
          ),
        ),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.blueAccent, Colors.indigo],
                  ),
                ),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/me.jpeg'),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Chasoul UIX',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Teknik Informatika',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'NPM: 12522028',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, size: 20, color: Colors.white),
                title: const Text('Home', style: TextStyle(fontSize: 14, color: Colors.white)),
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, size: 20, color: Colors.white),
                title: const Text('Info', style: TextStyle(fontSize: 14, color: Colors.white)),
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, size: 20, color: Colors.white),
                title: const Text('Agenda', style: TextStyle(fontSize: 14, color: Colors.white)),
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.article, size: 20, color: Colors.white),
                title: const Text('Gallery', style: TextStyle(fontSize: 14, color: Colors.white)),
                onTap: () {
                  _onItemTapped(3);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, size: 20),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 20),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article, size: 20),
            label: 'Galery',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        backgroundColor: Colors.grey[900],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}