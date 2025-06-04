import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/core/utils/email_validator.dart';
import 'package:prone/core/utils/password_validator.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_state.dart';
import 'package:prone/feature/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:prone/l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  final void Function() onRegister;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key, required this.onRegister});

  void login(BuildContext context) {
    context.read<AuthCubit>().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          //Show loading indicator if state is AuthLoading
          bool isLoading = state is AuthLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Email CustomTextFormField
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: AppLocalizations.of(context)!.email,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    textInputAction: TextInputAction.next,
                    validator: EmailValidator.validate,
                  ),
                  const SizedBox(height: 16),

                  //Password CustomTextFormField
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: AppLocalizations.of(context)!.password,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    textInputAction: TextInputAction.done,
                    validator: PasswordValidator.validate,
                    onEditingComplete: () {
                      if (_formKey.currentState!.validate()) {
                        login(context);
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Login button or loading indicator
                  if (isLoading)
                    const CircularProgressIndicator() // Loading indicator
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Form geçerliyse Cubit metodunu çağır
                          login(context);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.login),
                    ),
                  const SizedBox(height: 16),

                  // Register button
                  TextButton(
                    onPressed: isLoading ? null : onRegister,
                    child: Text(AppLocalizations.of(context)!.dontHaveAccount),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
