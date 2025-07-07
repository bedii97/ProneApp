import 'dart:math';

import 'package:flutter/material.dart';

class CreateQuizResultsPage extends StatefulWidget {
  const CreateQuizResultsPage({super.key});

  @override
  State<CreateQuizResultsPage> createState() => _CreateQuizResultsPageState();
}

class _CreateQuizResultsPageState extends State<CreateQuizResultsPage> {
  // Mock data for UI testing
  final List<Map<String, dynamic>> _mockResults = [];

  //Predefined icons
  final List<String> _availableIcons = [
    'emoji_events',
    'palette',
    'analytics',
    'groups',
    'psychology',
    'favorite',
    'star',
    'local_fire_department',
    'lightbulb',
    'bolt',
    'nature_people',
    'celebration',
  ];

  //Predefined colors
  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
  ];

  // Predefined result templates
  final List<Map<String, dynamic>> _resultTemplates = [
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

  void _addResult() {
    //Create a new result with random color and icon
    Random rnd = Random();
    setState(() {
      _mockResults.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': '',
        'description': '',
        'icon': _availableIcons[rnd.nextInt(_availableIcons.length)],
        'color': _availableColors[rnd.nextInt(_availableColors.length)],
      });
    });

    // TODO: context.read<CreateQuizCubit>().addResult(newResult);
  }

  void _addResultFromTemplate(Map<String, dynamic> template) {
    setState(() {
      _mockResults.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': template['title'],
        'description': template['description'],
        'icon': template['icon'],
        'color': template['color'],
      });
    });

    // TODO: context.read<CreateQuizCubit>().addResultFromTemplate(template);
  }

  void _removeResult(int index) {
    setState(() {
      _mockResults.removeAt(index);
    });

    // TODO: context.read<CreateQuizCubit>().removeResult(index);
  }

  void _duplicateResult(int index) {
    setState(() {
      final original = _mockResults[index];
      _mockResults.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': '${original['title']} (kopya)',
        'description': original['description'],
        'icon': original['icon'],
        'color': original['color'],
      });
    });

    // TODO: context.read<CreateQuizCubit>().duplicateResult(index);
  }

  void _updateResult(int index, Map<String, dynamic> updatedData) {
    setState(() {
      _mockResults[index] = {..._mockResults[index], ...updatedData};
    });

    // TODO: context.read<CreateQuizCubit>().updateResult(index, result);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with BlocBuilder<CreateQuizCubit, CreateQuizState>
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 24),

                // Quick Templates (if no results yet)
                if (_mockResults.isEmpty) _buildQuickTemplates(),

                // Results List
                if (_mockResults.isEmpty)
                  _buildEmptyState()
                else
                  ..._mockResults.asMap().entries.map((entry) {
                    final index = entry.key;
                    final result = entry.value;
                    return _buildResultCard(result, index);
                  }),

                const SizedBox(height: 16),

                // Add Result Button
                _buildAddResultButton(),

                const SizedBox(height: 32),

                // Requirements Info
                _buildRequirementsInfo(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Quiz Sonuçları',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _mockResults.length >= 2
                    ? Colors.green[100]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_mockResults.length} sonuç',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _mockResults.length >= 2
                      ? Colors.green[700]
                      : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Quiz tamamlandığında kullanıcılara gösterilecek farklı sonuçları tanımlayın.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildQuickTemplates() {
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
          children: _resultTemplates.map((template) {
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
        _getIconData(template['icon']),
        size: 18,
        color: template['color'],
      ),
      label: Text(template['title']),
      onPressed: () => _addResultFromTemplate(template),
      backgroundColor: (template['color'] as Color).withValues(alpha: 0.1),
      side: BorderSide(color: template['color']),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'İlk sonucunuzu ekleyin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Quiz için en az 2 farklı sonuç gereklidir',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (result['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Sonuç ${index + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: result['color'],
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  onSelected: (value) {
                    switch (value) {
                      case 'duplicate':
                        _duplicateResult(index);
                        break;
                      case 'delete':
                        _removeResult(index);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy, size: 18),
                          SizedBox(width: 8),
                          Text('Kopyala'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Sil', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Result Title
            TextFormField(
              initialValue: result['title'],
              decoration: const InputDecoration(
                labelText: 'Sonuç başlığı',
                hintText: 'Örn: Yaratıcı Tip',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _updateResult(index, {'title': value});
              },
            ),
            const SizedBox(height: 16),

            // Result Description
            TextFormField(
              initialValue: result['description'],
              decoration: const InputDecoration(
                labelText: 'Sonuç açıklaması',
                hintText: 'Bu sonuca uyan kişinin özelliklerini açıklayın...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                _updateResult(index, {'description': value});
              },
            ),
            const SizedBox(height: 16),

            // Visual Settings
            // Row(
            //   children: [
            //     Expanded(child: _buildIconSelector(result, index)),
            //     const SizedBox(width: 16),
            //     Expanded(child: _buildColorSelector(result, index)),
            //   ],
            // ),

            // Preview
            const SizedBox(height: 16),
            _buildResultPreview(result),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSelector(Map<String, dynamic> result, int index) {
    final availableIcons = [
      'emoji_events',
      'palette',
      'analytics',
      'groups',
      'psychology',
      'favorite',
      'star',
      'local_fire_department',
      'lightbulb',
      'bolt',
      'nature_people',
      'celebration',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'İkon',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableIcons.length,
            itemBuilder: (context, iconIndex) {
              final iconName = availableIcons[iconIndex];
              final isSelected = result['icon'] == iconName;

              return GestureDetector(
                onTap: () {
                  _updateResult(index, {'icon': iconName});
                },
                child: Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (result['color'] as Color).withValues(alpha: 0.2)
                        : null,
                    border: isSelected
                        ? Border.all(color: result['color'])
                        : null,
                  ),
                  child: Icon(
                    _getIconData(iconName),
                    color: isSelected ? result['color'] : Colors.grey[600],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector(Map<String, dynamic> result, int index) {
    final availableColors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Renk',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableColors.map((color) {
            final isSelected = result['color'] == color;
            return GestureDetector(
              onTap: () {
                _updateResult(index, {'color': color});
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResultPreview(Map<String, dynamic> result) {
    final title = result['title'] as String;
    final description = result['description'] as String;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Önizleme',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (result['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(result['icon']),
                  color: result['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty ? 'Başlık girilmedi' : title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: title.isEmpty ? Colors.grey : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description.isEmpty ? 'Açıklama girilmedi' : description,
                      style: TextStyle(
                        fontSize: 14,
                        color: description.isEmpty
                            ? Colors.grey
                            : Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddResultButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addResult,
        icon: const Icon(Icons.add),
        label: const Text('Yeni sonuç ekle'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.blue[300]!),
        ),
      ),
    );
  }

  Widget _buildRequirementsInfo() {
    final hasEnoughResults = _mockResults.length >= 2;
    final hasValidResults = _mockResults.every(
      (r) =>
          (r['title'] as String).trim().isNotEmpty &&
          (r['description'] as String).trim().isNotEmpty,
    );
    final isComplete = hasEnoughResults && hasValidResults;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isComplete ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isComplete ? Icons.check_circle : Icons.info_outline,
                color: isComplete ? Colors.green[600] : Colors.orange[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isComplete ? 'Tamamlandı!' : 'Eksik gereksinimler',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isComplete ? Colors.green[700] : Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRequirementItem('En az 2 sonuç', hasEnoughResults),
          _buildRequirementItem('Tüm sonuçlar doldurulmuş', hasValidResults),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check : Icons.radio_button_unchecked,
            size: 16,
            color: isCompleted ? Colors.green[600] : Colors.grey[500],
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isCompleted ? Colors.green[700] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'emoji_events': Icons.emoji_events,
      'palette': Icons.palette,
      'analytics': Icons.analytics,
      'groups': Icons.groups,
      'psychology': Icons.psychology,
      'favorite': Icons.favorite,
      'star': Icons.star,
      'local_fire_department': Icons.local_fire_department,
      'lightbulb': Icons.lightbulb,
      'bolt': Icons.bolt,
      'nature_people': Icons.nature_people,
      'celebration': Icons.celebration,
    };

    return iconMap[iconName] ?? Icons.help;
  }
}
