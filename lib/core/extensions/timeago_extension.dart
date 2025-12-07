import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

extension TimeagoExtension on DateTime {
  String timeAgo(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return timeago.format(this, locale: languageCode);
  }
}
