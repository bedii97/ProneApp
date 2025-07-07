import 'package:flutter/material.dart';

class QuizIconHelper {
  static final Map<String, IconData> _iconMap = {
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

  static IconData getIconData(String iconName) {
    return _iconMap[iconName] ?? Icons.help;
  }

  static List<String> get availableIcons => _iconMap.keys.toList();
}
