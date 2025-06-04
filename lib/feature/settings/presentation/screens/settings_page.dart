import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:prone/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:prone/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // const AppLogoMedium(),
          Icon(Icons.settings, size: 100),
          const Divider(height: 30, thickness: 5),
          // Tema
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return SwitchListTile(
                value: state
                    .isDarkMode, // Varsayılan tema durumu (örneğin: false = açık tema)
                onChanged: (bool value) {
                  // Tema değiştirme
                  context.read<SettingsCubit>().toggleTheme();
                },
                secondary: const Icon(Icons.brightness_6),
                title: Text(AppLocalizations.of(context)!.darkMode),
              );
            },
          ),
          const Divider(),

          // Dil Seçeneği
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return ListTile(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.language),
                subtitle: Text(
                  state.languageCode == 'en'
                      ? 'English'
                      : state.languageCode == 'tr'
                      ? 'Türkçe'
                      : 'Unknown',
                ),
                onTap: () {
                  _showLanguageSelectionDialog(context);
                },
              );
            },
          ),
          // Hesap Ayarları
          // ListTile(
          //   leading: const Icon(Icons.person),
          //   title: Text(AppLocalizations.of(context)!.accountSettings),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return BlocProvider(
          //             create: (context) =>
          //                 UserCubit(userRepo: SupabaseUserRepo()),
          //             child: const AccountSettingsScreen(),
          //           );
          //         },
          //       ),
          //     );
          //     // Navigator.pop(context);
          //   },
          // ),
          const Divider(),
          // Çıkış Yap
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logoutAction),
            onTap: () {
              context.read<AuthCubit>().logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    //Her dil, diğer her dilde aynı gözükmesi için HardCoded girildi
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  context.read<SettingsCubit>().changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Türkçe'),
                onTap: () {
                  context.read<SettingsCubit>().changeLanguage('tr');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
