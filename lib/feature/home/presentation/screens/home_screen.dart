import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prone/core/routes/app_router.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:prone/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:prone/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homeScreen),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<SettingsCubit>().toggleTheme();
              },
              child: const Text('Change the theme'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/settings');
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRouter.createPost);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
