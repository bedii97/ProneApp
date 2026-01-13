import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/data/supabase_post_repo.dart';
import 'package:prone/feature/post/presentation/cubits/poll/poll_detail_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/poll/poll_detail_state.dart';
import 'package:prone/feature/post/presentation/widgets/poll_detail/poll_detail_error_widget.dart';
import 'package:prone/feature/post/presentation/widgets/poll_detail/poll_detail_loaded_widget.dart';

class PollDetailScreen extends StatelessWidget {
  final String pollId;

  const PollDetailScreen({super.key, required this.pollId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Anket Detayı', // Görseldeki başlık
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: BlocProvider(
        create: (context) =>
            PollDetailCubit(postRepo: context.read<SupabasePostRepo>())
              ..loadPoll(pollId),
        child: BlocBuilder<PollDetailCubit, PollDetailState>(
          builder: (context, state) {
            return RefreshIndicator(
              child: Builder(
                builder: (context) {
                  if (state is PollDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PollDetailLoaded) {
                    return PollDetailLoadedWidget(
                      poll: state.poll,
                      onVote: (optionId) {
                        context.read<PollDetailCubit>().vote(state.poll.id!, [
                          optionId,
                        ]);
                      },
                    );
                  } else if (state is PollDetailError) {
                    return PollDetailErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<PollDetailCubit>().loadPoll(pollId);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              onRefresh: () => context.read<PollDetailCubit>().loadPoll(pollId),
            );
          },
        ),
      ),
    );
  }
}
