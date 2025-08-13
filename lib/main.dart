import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prone/core/routes/app_router.dart';
import 'package:prone/feature/auth/data/supabase_auth_repo.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:prone/feature/home/presentation/cubits/home_cubit.dart';
import 'package:prone/feature/post/data/supabase_post_repo.dart';
import 'package:prone/feature/post/presentation/cubits/post_cubit.dart';
import 'package:prone/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:prone/l10n/app_localizations.dart';
import 'package:prone/l10n/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Cubits
  late final AuthCubit _authCubit;
  late final SettingsCubit _settingsCubit;
  late final PostCubit _postCubit;
  late final HomeCubit _homeCubit;
  //Router
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit(SupabaseAuthRepo())..checkAuthStatus();
    _settingsCubit = SettingsCubit();
    _postCubit = PostCubit(SupabasePostRepo());
    _homeCubit = HomeCubit(postRepo: SupabasePostRepo());
    _router = AppRouter.router(_authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    _settingsCubit.close();
    _postCubit.close();
    _homeCubit.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider.value(value: _settingsCubit),
        BlocProvider.value(value: _postCubit),
        BlocProvider.value(value: _homeCubit),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Prone',
            theme: state.themeData,
            routerConfig: _router, // Sabit router kullan
            supportedLocales: L10n.all,
            locale: Locale(state.languageCode),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
