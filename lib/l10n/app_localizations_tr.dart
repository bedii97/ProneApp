// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get email => 'Email';

  @override
  String get homeScreen => 'Anasayfa';

  @override
  String get language => 'Dil';

  @override
  String get logoutAction => 'Çıkış Yap';

  @override
  String get password => 'Şifre';

  @override
  String get settings => 'Ayarlar';

  @override
  String get wrongPassword => 'Hatalı Şifre';

  @override
  String get login => 'Giriş Yap';

  @override
  String get dontHaveAccount => 'Hesabın yok mu? Kayıt Ol';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get username => 'Kullanıcı Adı';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get registrationSuccessful => 'Kayıt başarılı! Hoş geldiniz.';

  @override
  String get passwordMinLength => 'Şifre en az 6 karakter olmalı';

  @override
  String get confirmPasswordRequired => 'Şifreyi onaylayın';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get alreadyHaveAccount => 'Zaten hesabın var mı? Giriş Yap';
}
