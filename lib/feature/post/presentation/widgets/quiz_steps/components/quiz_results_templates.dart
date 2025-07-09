import 'package:flutter/material.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/helpers/quiz_icon_helper.dart';

class QuizResultsTemplates extends StatelessWidget {
  final Function(Map<String, dynamic>) onTemplateSelected;

  const QuizResultsTemplates({super.key, required this.onTemplateSelected});

  // Predefined result templates
  static final List<Map<String, dynamic>> _templates = [
    {
      'title': 'Lider',
      'description':
          'Doğuştan lider ruhlu, kararlı ve ilham verici bir kişiliğe sahipsiniz.',
      'icon': 'emoji_events',
      'color': Colors.amber,
    },
    {
      'title': 'Yaratıcı',
      'description':
          'Sanatsal ruha sahip, yaratıcı ve özgün fikirleri olan bir kişiliğiniz var.',
      'icon': 'palette',
      'color': Colors.purple,
    },
    {
      'title': 'Analist',
      'description':
          'Detaylara odaklanan, analitik düşünen ve problem çözen bir yaklaşımınız var.',
      'icon': 'analytics',
      'color': Colors.blue,
    },
    {
      'title': 'Sosyal',
      'description':
          'İnsanlarla iletişim kurmayı seven, empatik ve arkadaş canlısı bir kişiliğiniz var.',
      'icon': 'groups',
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Başlangıç Şablonları',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(
          'Aşağıdaki şablonlardan birini seçerek hızlıca başlayabilirsiniz.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _templates.map((template) {
            return _buildTemplateChip(template);
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTemplateChip(Map<String, dynamic> template) {
    return ActionChip(
      avatar: Icon(
        QuizIconHelper.getIconData(template['icon']),
        size: 18,
        color: template['color'],
      ),
      label: Text(template['title']),
      onPressed: () => onTemplateSelected(template),
      backgroundColor: (template['color'] as Color).withValues(alpha: 0.1),
      side: BorderSide(color: template['color']),
    );
  }
}
