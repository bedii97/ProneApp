import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/core/utils/email_validator.dart';
import 'package:prone/core/utils/username_validator.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_state.dart';
import 'package:prone/feature/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:prone/l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  final void Function() onLogin;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegisterScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Kayıt başarılı
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.registrationSuccessful,
                ),
                backgroundColor: Colors.green,
              ),
            );
            // Ana ekrana yönlendirme burada olacak
          }
          if (state is AuthFailure) {
            // Hata durumunda kullanıcıya mesaj göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is AuthLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.register,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: AppLocalizations.of(context)!.email,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      // Email validation
                      final emailError = EmailValidator.validate(value);
                      if (emailError != null) return emailError;

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _usernameController,
                    labelText: AppLocalizations.of(context)!.username,
                    prefixIcon: const Icon(Icons.person_outline),
                    textInputAction: TextInputAction.next,
                    validator: UsernameValidator.validate,
                    onChanged: (value) {
                      // Real-time normalization
                      final normalized = UsernameValidator.normalize(value);
                      if (normalized != value) {
                        _usernameController.value = _usernameController.value
                            .copyWith(
                              text: normalized,
                              selection: TextSelection.collapsed(
                                offset: normalized.length,
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: AppLocalizations.of(context)!.password,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return AppLocalizations.of(context)!.passwordMinLength;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _confirmPasswordController,
                    labelText: AppLocalizations.of(context)!.confirmPassword,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.confirmPasswordRequired;
                      }
                      if (value != _passwordController.text) {
                        return AppLocalizations.of(
                          context,
                        )!.passwordsDoNotMatch;
                      }
                      return null;
                    },
                    onEditingComplete: () {
                      if (_formKey.currentState!.validate()) {
                        _register(context);
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  if (isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _register(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(AppLocalizations.of(context)!.register),
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: isLoading ? null : onLogin,
                    child: Text(
                      AppLocalizations.of(context)!.alreadyHaveAccount,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _register(BuildContext context) {
    context.read<AuthCubit>().register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _usernameController.text.trim(),
    );
  }
}
