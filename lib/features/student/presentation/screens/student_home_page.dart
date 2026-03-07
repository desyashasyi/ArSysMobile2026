import 'package:arsys/features/auth/application/auth_provider.dart';
import 'package:arsys/features/auth/presentation/screens/login_page.dart';
import 'package:arsys/features/student/home/presentation/student_dashboard_page.dart';
import 'package:arsys/features/student/research/presentation/research_list_page.dart';
import 'package:arsys/features/student/event/presentation/student_event_page.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  ConsumerState<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  int _selectedIndex = 1; // Default to Home

  static const List<Widget> _pages = [
    StudentResearchListPage(),
    StudentDashboardPage(),
    StudentEventPage(),
  ];

  static const List<String> _titles = [
    'Research',
    'Home',
    'Event',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _onItemTapped(1);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          backgroundColor: Colors.purple[500],
          items: const [
            TabItem(icon: Icons.science, title: 'Research'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.event, title: 'Event'),
          ],
          initialActiveIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
