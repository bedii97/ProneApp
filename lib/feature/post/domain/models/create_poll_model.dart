import 'package:prone/feature/post/domain/models/create_option_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';

class CreatePollModel {
  final String title;
  final String? description;
  final PostType type;
  final PollSettings? pollSettings;
  final PostStatus status;
  final List<CreateOptionModel> options;

  const CreatePollModel({
    required this.title,
    this.description,
    required this.type,
    this.pollSettings,
    required this.options,
    this.status = PostStatus.active,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'poll_settings': pollSettings?.toJson(),
      'options': options.map((option) => option.text).toList(),
    };
  }
}
