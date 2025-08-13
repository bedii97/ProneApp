import 'dart:developer';

import 'package:prone/core/constants/supabase_constants.dart';
import 'package:prone/feature/post/domain/models/create_poll_model.dart';
import 'package:prone/feature/post/domain/models/create_quiz_model.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/models/quiz_model.dart';

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
      final response = await _supabase
          .from(SupabaseConstants.POSTS_TABLE)
          .select('''
          id,
          user_id,
          post_type,
          title,
          body,
          allow_multiple_answers,
          allow_adding_options,
          show_results_before_voting,
          expires_at,
          status,
          created_at,
          updated_at,
          users!posts_user_id_fkey (
            username,
            avatar_url
          ),
          poll_options (
            id,
            option_text,
            user_votes!user_votes_option_id_fkey (
              count
            )
          ),
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
                  id
                )
              )
            )
          ),
          quiz_results (
            id,
            title,
            description,
            image_url
          ),
          user_votes!user_votes_post_id_fkey (
            option_id
          ),
          quiz_completions!quiz_completions_post_id_fkey (
            result_id,
            total_points
          )
        ''')
          .eq('status', PostStatus.published.name)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      inspect(response.toString());

      final List<PostModel> posts = [];

      for (final postData in response as List) {
        final post = PostModel.fromJson(postData);
        posts.add(post);
      }

      return posts;
    } catch (e, stackTrace) {
      log('Error fetching posts', error: e, stackTrace: stackTrace);
      throw Exception('Failed to fetch posts: $e');
    }
  }
}
