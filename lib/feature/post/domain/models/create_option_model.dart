class CreateOptionModel {
  final String text;
  final String? createdBy;

  const CreateOptionModel({this.createdBy, required this.text});

  Map<String, dynamic> toJson() {
    return {'option_text': text, 'created_by_user_id': createdBy};
  }
}
