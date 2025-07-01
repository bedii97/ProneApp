import 'package:prone/feature/post/domain/models/post_model.dart';

abstract class PostState {}

// Initial state
class PostInitial extends PostState {}

// Loading states
class PostLoading extends PostState {}

class PostCreating extends PostState {}

// Success states
class PostCreated extends PostState {
  final PostModel post;
  PostCreated(this.post);
}

// Error states
class PostError extends PostState {
  final String message;
  PostError(this.message);
}

// Posts loaded state
class PostsLoaded extends PostState {
  final List<PostModel> posts;
  PostsLoaded(this.posts);
}
