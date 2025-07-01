import 'package:prone/feature/post/domain/models/create_poll_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';

abstract class PostRepo {
  // Method to create a post
  Future<PostModel> createPoll({required CreatePollModel post});

  // Method to fetch all posts
  Future<List<Map<String, dynamic>>> fetchPosts();

  // Method to fetch a single post by ID
  Future<Map<String, dynamic>> fetchPostById(String postId);
}
