import 'dart:developer';

import 'package:prone/core/constants/supabase_constants.dart';
import 'package:prone/feature/post/domain/models/poll/create_poll_model.dart';
import 'package:prone/feature/post/domain/models/quiz/create_quiz_model.dart';
import 'package:prone/feature/post/domain/models/poll/poll_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_result_model.dart';

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

  User? _getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  @override
  Future<QuizModel> createQuiz({required CreateQuizModel quiz}) async {
    try {
      final user = _getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Edge function'a gönderilecek data'yı hazırla
      final requestData = {
        'title': quiz.title,
        'body': quiz.body,
        'allowMultipleAnswers': quiz.allowMultipleAnswers,
        'allowAddingOptions': quiz.allowAddingOptions,
        'showResultsBeforeVoting': quiz.showResultsBeforeVoting,
        'expiresAt': quiz.expiresAt?.toIso8601String(),
        'questions': quiz.questions
            .map(
              (question) => {
                'text': question.text,
                'options': question.options
                    .map(
                      (option) => {
                        'text': option.text,
                        'points': option.points,
                      },
                    )
                    .toList(),
              },
            )
            .toList(),
        'results': quiz.results
            .map(
              (result) => {
                'title': result.title,
                'description': result.description,
                'imageUrl': result.imageUrl,
              },
            )
            .toList(),
      };

      // Edge function'ı çağır
      final response = await _supabase.functions.invoke(
        'create-quiz',
        body: requestData,
      );

      if (response.status != 201) {
        final error = response.data?['error'] ?? 'Unknown error';
        throw Exception('Quiz creation failed: $error');
      }

      final quizId = response.data['quiz_id'];
      // Quiz'i database'den fetch et ve QuizModel olarak return et
      final quizData = await _supabase
          .from(SupabaseConstants.POSTS_TABLE)
          .select('''
          *,
          quiz_questions (
            id,
            question_text,
            order_index,
            quiz_options (
              id,
              option_text,
              quiz_result_mappings (
                points,
                quiz_results (
                  id,
                  title,
                  description,
                  image_url
                )
              )
            )
          ),
          quiz_results (
            id,
            title,
            description,
            image_url
          )
        ''')
          .eq('id', quizId)
          .single();
      // return QuizModel.fromJson(quizData);
      final quizModel = QuizModel.fromJson(quizData);

      return quizModel;
    } catch (e, stackTrace) {
      log('Error creating quiz', error: e, stackTrace: stackTrace);
      throw Exception('Quiz creation failed: $e');
    }
  }

  @override
  Future<List<PostModel>> fetchPosts({int offset = 0, int limit = 10}) async {
    try {
      final response = await _supabase.functions.invoke(
        'fetch-home-posts',
        body: {'offset': offset, 'limit': limit},
      );

      if (response.status != 200) {
        throw Exception('Function error: ${response.status}');
      }

      final List<dynamic> data = response.data;

      final deneme = data.map((e) => PostModel.fromJson(e)).toList();
      inspect(response.data);
      return deneme;
    } catch (e, stackTrace) {
      log(
        'Error fetching posts via Edge Function',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<PollModel> getPollById(String pollId) async {
    try {
      // Edge Function'ı çağırıyoruz
      final response = await _supabase.functions.invoke(
        'fetch-post-details', // Edge function isminiz
        body: {'postId': pollId},
      );

      if (response.status != 200) {
        throw Exception('Failed to fetch poll details: ${response.data}');
      }

      final data = response.data;

      // Debug için
      inspect(data);

      // Gelen JSON, anasayfadan gelen yapı ile birebir aynı olduğu için
      // mevcut PollModel.fromJson yapınız muhtemelen hatasız çalışacaktır.
      return PollModel.fromJson(data);
    } catch (e, stackTrace) {
      log('Error fetching poll', error: e, stackTrace: stackTrace);
      throw Exception('Failed to fetch poll: $e');
    }
  }

  @override
  Future<void> voteOnPoll({
    required String pollId,
    required List<String> optionIds,
  }) async {
    //Todo: It will support multiple votes in the future
    try {
      await _supabase.from(SupabaseConstants.VOTES_TABLE).upsert({
        'post_id': pollId,
        'option_id': optionIds.first,
        'user_id': _getCurrentUser()?.id,
      }).select();
    } catch (e, stackTrace) {
      log('Error voting on poll', error: e, stackTrace: stackTrace);
      throw Exception('Failed to vote on poll: $e');
    }
  }

  @override
  Future<QuizModel?> getQuizById(String quizId) async {
    try {
      final response = await _supabase.functions.invoke(
        'get-quiz-details',
        body: {'quizId': quizId},
      );

      final Map<String, dynamic> responseData = response.data;

      if (responseData['success'] == true) {
        inspect(responseData['data']);
        return QuizModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['error']);
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return null;
    }
  }

  @override
  Future<QuizResultModel?> submitQuiz({
    required String quizId,
    required Map<String, String> answers, // {questionId: optionId}
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'submit-quiz',
        body: {'quizId': quizId, 'answers': answers},
      );

      final responseData = response.data;

      if (responseData['success'] == true && responseData['result'] != null) {
        // Backend'den gelen sonucu modele çevir
        return QuizResultModel.fromJson(responseData['result']);
      } else {
        throw Exception(responseData['error'] ?? 'Sonuç hesaplanamadı.');
      }
    } catch (e) {
      // Hata yönetimi (Loglama vs.)
      print('Submit error: $e');
      rethrow;
    }
  }
}
