import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isAdmin = ValueNotifier<bool>(false);

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isAdmin,
              builder:
                  (context, isAdmin, _) => CheckboxListTile(
                    title: Text('Register as Admin'),
                    value: isAdmin,
                    onChanged: (value) => _isAdmin.value = value!,
                  ),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<AuthProvider>().register(
                  _emailController.text,
                  _passwordController.text,
                  _isAdmin.value,
                );
                Navigator.pop(context);
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
