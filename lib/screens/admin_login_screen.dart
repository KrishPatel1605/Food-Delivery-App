
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'admin_orders_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _controller = TextEditingController();
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Admin Password',
              ),
            ),
            const SizedBox(height: 16),
            if (_showError) const Text('Invalid password', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final pass = dotenv.env['ADMIN_PASS'] ?? '';
                if (_controller.text.trim() == pass) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
                  );
                } else {
                  setState(() => _showError = true);
                }
              },
              child: const Text('Login as Admin'),
            )
          ],
        ),
      ),
    );
  }
}
