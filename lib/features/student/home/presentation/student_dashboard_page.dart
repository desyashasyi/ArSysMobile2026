import 'package:arsys/features/auth/application/auth_provider.dart';
import 'package:arsys/features/shared/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentDashboardPage extends ConsumerWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final studentName = user?['name'] ?? 'Student';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
                      studentName.toString().isNotEmpty ? studentName.toString()[0].toUpperCase() : 'S',
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
                        Text(studentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
        ],
      ),
    );
  }
}
