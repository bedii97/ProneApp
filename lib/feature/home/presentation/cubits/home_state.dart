import 'package:prone/feature/post/domain/models/post_model.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<PostModel> posts; // PollModel ve QuizModel karışık liste
  final bool hasMore;
  final bool isLoadingMore;

  const HomeLoaded({
    required this.posts,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  HomeLoaded copyWith({
    List<PostModel>? posts,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return HomeLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class HomeRefreshing extends HomeState {
  final List<PostModel> posts; // Refresh sırasında mevcut postları göster

  const HomeRefreshing({required this.posts});
}

class HomeError extends HomeState {
  final String message;
  final List<PostModel>? cachedPosts; // Error durumunda cached postları göster

  const HomeError({required this.message, this.cachedPosts});
}

class HomeEmpty extends HomeState {
  const HomeEmpty();
}
