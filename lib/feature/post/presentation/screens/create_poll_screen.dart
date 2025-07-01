import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prone/feature/post/domain/models/create_option_model.dart';
import 'package:prone/feature/post/domain/models/create_poll_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/presentation/cubits/post_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/post_state.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool _allowMultipleVotes = false;
  bool _showResultsAfterVote = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers[index].dispose();
        _optionControllers.removeAt(index);
      });
    }
  }

  void _createPoll() {
    if (_formKey.currentState!.validate()) {
      final options = _optionControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      if (options.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('En az 2 seçenek eklemelisiniz')),
        );
        return;
      }

      final pollSettings = PollSettings(
        allowMultipleVotes: _allowMultipleVotes,
      );

      final post = CreatePollModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        type: PostType.poll,
        pollSettings: pollSettings,
        options: options.map((text) => CreateOptionModel(text: text)).toList(),
      );

      context.read<PostCubit>().createPoll(post);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anket Oluştur'),
        actions: [
          BlocConsumer<PostCubit, PostState>(
            listener: (context, state) {
              if (state is PostCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Anket başarıyla oluşturuldu!'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.pop();
              } else if (state is PostError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is PostCreating ? null : _createPoll,
                child: state is PostCreating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Yayınla',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poll Question
              const Text(
                'Anket Sorusu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Anket sorunuzu yazın...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Anket sorusu gereklidir';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description (optional)
              const Text(
                'Açıklama (İsteğe bağlı)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Anket hakkında detay verin...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Poll Type Settings
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Anket Ayarları',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Multiple Selection Toggle
                      SwitchListTile(
                        title: const Text('Çoklu seçime izin ver'),
                        subtitle: Text(
                          _allowMultipleVotes
                              ? 'Kullanıcılar birden fazla seçenek işaretleyebilir'
                              : 'Kullanıcılar sadece bir seçenek işaretleyebilir',
                        ),
                        value: _allowMultipleVotes,
                        onChanged: (value) {
                          setState(() {
                            _allowMultipleVotes = value;
                          });
                        },
                      ),

                      const Divider(),

                      // Show Results After Vote
                      SwitchListTile(
                        title: const Text('Sonuçları göster'),
                        subtitle: Text(
                          _showResultsAfterVote
                              ? 'Kullanıcılar oy verdikten sonra sonuçları görebilir'
                              : 'Sonuçlar gizli kalır',
                        ),
                        value: _showResultsAfterVote,
                        onChanged: (value) {
                          setState(() {
                            _showResultsAfterVote = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Poll Options
              const Text(
                'Seçenekler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Dynamic Options
              ...List.generate(_optionControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Seçenek ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (index < 2 &&
                                (value == null || value.trim().isEmpty)) {
                              return 'Bu seçenek gereklidir';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_optionControllers.length > 2)
                        IconButton(
                          onPressed: () => _removeOption(index),
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.red,
                        ),
                    ],
                  ),
                );
              }),

              // Add Option Button
              TextButton.icon(
                onPressed: _optionControllers.length < 10 ? _addOption : null,
                icon: const Icon(Icons.add),
                label: const Text('Seçenek Ekle'),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
