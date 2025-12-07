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
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _initializeTimeAgo();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());
}

void _initializeTimeAgo() {
  timeago.setLocaleMessages('tr', timeago.TrMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => SupabaseAuthRepo()),
        RepositoryProvider(create: (context) => SupabasePostRepo()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(context.read<SupabaseAuthRepo>())..checkAuthStatus(),
          ),
          BlocProvider(create: (context) => SettingsCubit()),
          BlocProvider(
            create: (context) => PostCubit(context.read<SupabasePostRepo>()),
          ),
          BlocProvider(
            create: (context) =>
                HomeCubit(postRepo: context.read<SupabasePostRepo>()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    _router = AppRouter.router(authCubit);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Prone',
          theme: state.themeData,
          routerConfig: _router,
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
    );
  }
}
