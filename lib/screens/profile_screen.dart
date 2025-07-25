
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';
import 'login_screen.dart';
import 'my_orders_screen.dart';
import 'admin_login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: user == null
          ? const Center(child: Text('Not logged in'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Text(user.email != null && user.email!.isNotEmpty ? user.email![0].toUpperCase() : '?'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.email ?? 'User', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text(user.uid, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('My Orders'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MyOrdersScreen()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Admin'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen()));
                    },
                  ),
                  const Spacer(),
                  FilledButton.tonal(
                    onPressed: () async {
                      await ref.read(authRepositoryProvider).signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text('Logout'),
                  )
                ],
              ),
            ),
    );
  }
}
