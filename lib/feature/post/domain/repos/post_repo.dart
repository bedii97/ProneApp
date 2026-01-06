import 'package:prone/feature/post/domain/models/poll/create_poll_model.dart';
import 'package:prone/feature/post/domain/models/quiz/create_quiz_model.dart';
import 'package:prone/feature/post/domain/models/poll/poll_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_result_model.dart';

abstract class PostRepo {
  // Method to create a post
  Future<PollModel> createPoll({required CreatePollModel post});

  // Method to create a quiz (Edge Function)
  Future<QuizModel> createQuiz({required CreateQuizModel quiz}); // eklendi

  // Method to fetch all posts
  Future<List<PostModel>> fetchPosts({int offset = 1, int limit = 10});

  //Method to fetch poll details
  Future<PollModel> getPollById(String pollId);

  //Method to vote on a poll
  Future<void> voteOnPoll({
    required String pollId,
    required List<String> optionIds,
  });

  // Method to fetch quiz details
  Future<QuizModel?> getQuizById(String quizId);

  Future<QuizResultModel?> submitQuiz({
    required String quizId,
    required Map<String, String> answers, // {questionId: optionId}
  });
}
