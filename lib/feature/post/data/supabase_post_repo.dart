import 'dart:developer';

import 'package:prone/core/constants/supabase_constants.dart';
import 'package:prone/feature/post/domain/models/create_poll_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/repos/post_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePostRepo extends PostRepo {
  final _supabase = Supabase.instance.client;

  @override
  Future<PostModel> createPoll({required CreatePollModel post}) async {
    try {
      final user = _getCurrentUser();
      final postResponse = await _supabase
          .from(SupabaseConstants.POSTS_TABLE)
          .insert({
            'user_id': user?.id,
            'title': post.title,
            'description': post.description,
            'type': post.type.name,
            'status': post.status.name,
            'poll_settings': post.pollSettings?.toJson(),
          })
          .select()
          .single();
      inspect(postResponse);
      final createdPost = PostModel.fromJson(postResponse);

      // Insert options
      final optionsData = post.options
          .asMap()
          .entries
          .map(
            (entry) => {
              'post_id': createdPost.id,
              'text': entry.value.text,
              'order': entry.key,
            },
          )
          .toList();
      final optionResponse = await _supabase
          .from(SupabaseConstants.POST_OPTIONS_TABLE)
          .insert(optionsData)
          .select();

      return PostModel(
        id: createdPost.id,
        userId: createdPost.userId,
        title: createdPost.title,
        description: createdPost.description,
        type: createdPost.type,
        pollSettings: createdPost.pollSettings,
        createdAt: createdPost.createdAt,
        totalVotes: createdPost.totalVotes,
        userVoted: createdPost.userVoted,
        userVoteOption: createdPost.userVoteOption,
        options: optionResponse
            .map((option) => OptionModel.fromJson(option))
            .toList(),
      );
    } catch (e) {
      inspect(e);
      throw Exception('Post creation failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPostById(String postId) {
    // TODO: implement fetchPostById
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPosts() {
    // TODO: implement fetchPosts
    throw UnimplementedError();
  }

  User? _getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}
