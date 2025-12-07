import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_state.dart';
import 'package:prone/feature/auth/presentation/screens/auth_screen.dart';
import 'package:prone/feature/home/presentation/screens/home_screen.dart';
import 'package:prone/feature/post/presentation/screens/create_poll_screen.dart';
import 'package:prone/feature/post/presentation/screens/create_post_screen.dart';
import 'package:prone/feature/post/presentation/screens/create_quiz_screen.dart';
import 'package:prone/feature/post/presentation/screens/poll_detail_screen/poll_detail_screen.dart';
import 'package:prone/feature/settings/presentation/screens/settings_page.dart';

class AppRouter {
  static const String auth = '/auth';
  static const String home = '/';
  static const String settings = '/settings';
  static const String createPost = '/create-post';
  static const String createPoll = '/create-poll';
  static const String profile = '/profile';
  static const String pollDetail = '/poll/:id';
  static const String quizDetail = '/quiz/:id';
  static const String createQuizScreen = '/create-quiz';
  static const String createQuizBasicInfoScreen =
      '/create-quiz-basic-info-screen';

  static GoRouter router(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: auth,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final isAuthenticated = authState is AuthAuthenticated;
        final isAuthPage = state.matchedLocation == auth;

        // Loading durumunda yönlendirme yapma
        if (authState is AuthLoading) {
          return null;
        }

        // Kullanıcı giriş yapmış ve auth sayfasındaysa home'a yönlendir
        if (isAuthenticated && isAuthPage) {
          return home;
        }

        // Kullanıcı giriş yapmamış ve auth sayfasında değilse auth'a yönlendir
        if (!isAuthenticated && !isAuthPage) {
          return auth;
        }

        return null; // Yönlendirme yapma
      },
      routes: [
        GoRoute(
          path: auth,
          name: 'auth',
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: createPost,
          name: 'createPost',
          builder: (context, state) => const CreatePostScreen(),
        ),
        GoRoute(
          path: createPoll,
          name: 'createPoll',
          builder: (context, state) => const CreatePollScreen(),
        ),
        GoRoute(
          path: createQuizBasicInfoScreen,
          name: 'createQuizScreen',
          builder: (context, state) => const CreateQuizScreen(),
        ),
        GoRoute(
          path: pollDetail,
          name: 'pollDetail',
          builder: (context, state) {
            final pollId = state.pathParameters['id'] ?? '';
            return PollDetailScreen(pollId: pollId);
          },
        ),
      ],
    );
  }
}

// AuthCubit stream'ini GoRouter ile senkronize etmek için
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
