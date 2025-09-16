import 'package:prone/feature/post/domain/models/create_poll_model.dart';
import 'package:prone/feature/post/domain/models/create_quiz_model.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/models/quiz_model.dart';

abstract class PostRepo {
  // Method to create a post
  Future<PollModel> createPoll({required CreatePollModel post});

  // Method to create a quiz (Edge Function)
  Future<QuizModel> createQuiz({required CreateQuizModel quiz}); // eklendi

  // Method to fetch all posts
  Future<List<PostModel>> fetchPosts({int offset = 1, int limit = 10});

  // Method to fetch a single post by ID
  Future<Map<String, dynamic>> fetchPostById(String postId);

  //Method to fetch poll details
  Future<PollModel> getPollById(String pollId);
}
