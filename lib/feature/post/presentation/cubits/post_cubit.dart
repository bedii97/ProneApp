import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/create_poll_model.dart';
import 'package:prone/feature/post/domain/repos/post_repo.dart';
import 'package:prone/feature/post/presentation/cubits/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo _postRepo;

  PostCubit(this._postRepo) : super(PostInitial());

  // Method to create a post
  Future<void> createPoll(CreatePollModel post) async {
    try {
      emit(PostCreating());
      final createdPost = await _postRepo.createPoll(post: post);
      emit(PostCreated(createdPost));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
