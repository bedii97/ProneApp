import 'dart:developer';

import 'package:prone/core/constants/supabase_constants.dart';
import 'package:prone/feature/post/domain/models/create_poll_model.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';

import 'package:prone/feature/post/domain/repos/post_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePostRepo extends PostRepo {
  final _supabase = Supabase.instance.client;

  @override
  Future<PollModel> createPoll({required CreatePollModel post}) async {
    try {
      final user = _getCurrentUser();
      post = post.copyWith(userId: user?.id);
      final postResponse = await _supabase
          .from(SupabaseConstants.POSTS_TABLE)
          .insert(post.toPostJson())
          .select()
          .single();
      inspect(postResponse);

      //Insert Options
      final options = post.options
          .asMap()
          .entries
          .map(
            (entry) => {
              'post_id': postResponse['id'],
              'option_text': entry.value.text,
              'created_by_user_id': postResponse['user_id'],
            },
          )
          .toList();

      final optionResponse = await _supabase
          .from(SupabaseConstants.POLL_OPTIONS_TABLE)
          .insert(options)
          .select();

      inspect(optionResponse);
      return PollModel.fromJson(postResponse);
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
