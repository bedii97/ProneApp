// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get email => 'Email';

  @override
  String get homeScreen => 'Home Screen';

  @override
  String get language => 'Language';

  @override
  String get logoutAction => 'Logout';

  @override
  String get password => 'Password';

  @override
  String get settings => 'Settings';

  @override
  String get wrongPassword => 'Wrong Password';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign Up';

  @override
  String get register => 'Register';

  @override
  String get username => 'Username';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get registrationSuccessful => 'Registration successful! Welcome.';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get createPost => 'Create Post';

  @override
  String get whatTypeOfPost => 'What type of post do you want to create?';

  @override
  String get selectOneOption => 'Select one of the options below:';

  @override
  String get createPoll => 'Create Poll';

  @override
  String get customizablePoll => 'Create customizable poll';

  @override
  String get simplePollDescription =>
      'Choose from simple, multiple choice or open poll types';

  @override
  String get quizTest => 'Quiz/Test';

  @override
  String get resultBasedQuiz => 'Multi-question result-based quiz';

  @override
  String get quizDescription => 'Multiple questions and result categories';
}
