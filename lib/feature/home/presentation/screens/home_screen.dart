import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prone/core/routes/app_router.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:prone/feature/home/presentation/cubits/home_cubit.dart';
import 'package:prone/feature/home/presentation/cubits/home_state.dart';
import 'package:prone/feature/home/presentation/widgets/post_cards/poll_card.dart';
import 'package:prone/feature/home/presentation/widgets/post_cards/quiz_card.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';
import 'package:prone/feature/post/domain/models/quiz_model.dart';

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
            onPressed: () {
              context.push('/settings');
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  if (post is PollModel) {
                    return PollCard(poll: post);
                  } else if (post is QuizModel) {
                    return QuizCard(quiz: post);
                  }
                  return const SizedBox.shrink();
                },
              );
            }
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<HomeCubit>().fetchPosts();
                },
                child: Text("Retry"),
              ),
            );
          },
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
