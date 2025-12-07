import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/haptic_widgets.dart';

class EmailLoginForm extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;

  const EmailLoginForm({
    super.key,
    required this.onLogin,
    this.isLoading = false,
  });

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AbsorbPointer(
      absorbing: widget.isLoading,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'auth_email_label'.tr(),
                hintText: 'auth_email_hint'.tr(),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'auth_email_required'.tr();
                }
                if (!_isValidEmail(value)) {
                  return 'auth_email_invalid'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: DesignTokens.spacingL),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleLogin(),
              decoration: InputDecoration(
                labelText: 'auth_password_label'.tr(),
                hintText: 'auth_password_hint'.tr(),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'auth_password_required'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: DesignTokens.spacingXl),
            HapticFilledButton(
              onPressed: widget.isLoading ? null : _handleLogin,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingM),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.isLoading
                    ? SizedBox(
                        key: const ValueKey('login-loading'),
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
                        ),
                      )
                    : Text(
                        'auth_login_button'.tr(),
                        key: const ValueKey('login-text'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

