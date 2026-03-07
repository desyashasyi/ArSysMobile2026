import 'package:arsys/features/auth/application/auth_provider.dart';
import 'package:arsys/features/auth/presentation/screens/login_page.dart';
import 'package:arsys/features/staff/pre_defense/presentation/pre_defense_list_page.dart';
import 'package:arsys/features/staff/review/presentation/review_list_page.dart';
import 'package:arsys/features/staff/supervise/presentation/supervise_list_page.dart';
import 'package:arsys/features/staff/final_defense/presentation/final_defense_list_page.dart';
import 'package:arsys/features/shared/profile/presentation/profile_page.dart';
import 'package:arsys/features/program/presentation/pre_defense_scores_page.dart';
import 'package:arsys/features/program/presentation/final_defense_scores_page.dart';
import 'package:arsys/features/program/presentation/approval_list_page.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 2; // Default to Home

  static const List<Widget> _pages = [
    SuperviseListPage(),
    ReviewListPage(),
    _HomeContent(),
    PreDefenseListPage(),
    FinalDefenseListPage(),
  ];

  static const List<String> _titles = [
    'Supervised Research',
    'Review',
    'Home',
    'Pre-Defense',
    'Final Defense',
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
      canPop: _selectedIndex == 2,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _onItemTapped(2);
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
            TabItem(icon: Icons.supervisor_account, title: 'Supervise'),
            TabItem(icon: Icons.checklist, title: 'Review'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.gavel, title: 'Pre'),
            TabItem(icon: Icons.workspace_premium, title: 'Final'),
          ],
          initialActiveIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final userName = user?['name'] ?? 'Staff';
    final isKaprodi = ref.watch(isKaprodiProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome card
          Card(
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      userName.toString().isNotEmpty ? userName.toString()[0].toUpperCase() : 'S',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome,', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 2),
                        Text(userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage())),
                    icon: const Icon(Icons.person, size: 16, color: Colors.white),
                    label: const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Program Menu (kaprodi only, quick access card style)
          if (isKaprodi) ...[
            const SizedBox(height: 20),
            Text('Program Menu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800])),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildMenuCard(
                  context,
                  icon: Icons.gavel,
                  label: 'Pre-Defense\nScores',
                  color: Colors.orange,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreDefenseScoresPage())),
                ),
                const SizedBox(width: 10),
                _buildMenuCard(
                  context,
                  icon: Icons.workspace_premium,
                  label: 'Final Defense\nScores',
                  color: Colors.deepPurple,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FinalDefenseScoresPage())),
                ),
                const SizedBox(width: 10),
                _buildMenuCard(
                  context,
                  icon: Icons.approval,
                  label: 'Defense\nApproval',
                  color: Colors.amber.shade700,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ApprovalListPage())),
                ),
              ],
            ),
          ],

          const SizedBox(height: 32),

          // ArSys branding
          Center(
            child: Column(
              children: [
                Icon(Icons.school, size: 64, color: Colors.purple[200]),
                const SizedBox(height: 12),
                Text('ArSys', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple[700])),
                const SizedBox(height: 4),
                Text('Academic Research System', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: color),
                const SizedBox(height: 8),
                Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
