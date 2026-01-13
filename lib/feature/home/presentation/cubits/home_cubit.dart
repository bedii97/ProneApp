import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/home/presentation/cubits/home_state.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/repos/post_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final PostRepo _postRepo;

  static const int _postsPerPage = 10;
  int _currentPage = 0;
  List<PostModel> _allPosts = [];

  HomeCubit({required PostRepo postRepo})
    : _postRepo = postRepo,
      super(const HomeInitial());

  Future<void> bedii() async {
    try {
      final posts = await _postRepo.fetchPosts(
        limit: _postsPerPage,
        offset: _currentPage * _postsPerPage,
      );
      inspect(posts);
    } catch (e) {
      inspect(e);
    }
  }

  // İlk postları yükle
  Future<void> fetchPosts() async {
    try {
      emit(const HomeLoading());

      _currentPage = 0;
      final posts = await _postRepo.fetchPosts(
        limit: _postsPerPage,
        offset: _currentPage * _postsPerPage,
      );

      if (posts.isEmpty) {
        emit(const HomeEmpty());
        return;
      }

      _allPosts = posts;
      _currentPage++;

      emit(HomeLoaded(posts: posts, hasMore: posts.length >= _postsPerPage));
    } catch (error) {
      emit(HomeError(message: error.toString()));
    }
  }

  // Pull-to-refresh
  Future<void> refreshPosts() async {
    if (state is HomeLoaded) {
      final currentPosts = (state as HomeLoaded).posts;
      emit(HomeRefreshing(posts: currentPosts));
    }

    try {
      _currentPage = 0;
      final posts = await _postRepo.fetchPosts(limit: _postsPerPage, offset: 0);

      if (posts.isEmpty) {
        emit(const HomeEmpty());
        return;
      }

      _allPosts = posts;
      _currentPage++;

      emit(HomeLoaded(posts: posts, hasMore: posts.length >= _postsPerPage));
    } catch (error) {
      // Refresh hatası durumunda eski postları geri yükle
      if (_allPosts.isNotEmpty) {
        emit(HomeLoaded(posts: _allPosts));
      } else {
        emit(HomeError(message: error.toString()));
      }
    }
  }

  // Infinite scroll için daha fazla post yükle
  Future<void> loadMorePosts() async {
    final currentState = state;
    if (currentState is! HomeLoaded ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final newPosts = await _postRepo.fetchPosts(
        limit: _postsPerPage,
        offset: _currentPage * _postsPerPage,
      );

      if (newPosts.isEmpty) {
        emit(currentState.copyWith(isLoadingMore: false, hasMore: false));
        return;
      }

      _allPosts.addAll(newPosts);
      _currentPage++;

      emit(
        HomeLoaded(
          posts: List.from(_allPosts),
          hasMore: newPosts.length >= _postsPerPage,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  // Yeni oluşturulan post'u feed'in başına ekle
  void addNewPost(dynamic post) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      _allPosts.insert(0, post);
      emit(
        HomeLoaded(posts: List.from(_allPosts), hasMore: currentState.hasMore),
      );
    }
  }

  // Post güncellendiğinde (oy verme sonrası) güncelle
  void updatePost(dynamic updatedPost) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final index = _allPosts.indexWhere((post) {
        if (post.runtimeType == updatedPost.runtimeType) {
          return post.id == updatedPost.id;
        }
        return false;
      });

      if (index != -1) {
        _allPosts[index] = updatedPost;
        emit(
          HomeLoaded(
            posts: List.from(_allPosts),
            hasMore: currentState.hasMore,
          ),
        );
      }
    }
  }

  // Post silme
  void removePost(String postId) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      _allPosts.removeWhere((post) => post.id == postId);

      if (_allPosts.isEmpty) {
        emit(const HomeEmpty());
      } else {
        emit(
          HomeLoaded(
            posts: List.from(_allPosts),
            hasMore: currentState.hasMore,
          ),
        );
      }
    }
  }
}
