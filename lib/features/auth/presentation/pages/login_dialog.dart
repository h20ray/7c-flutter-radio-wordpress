import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/email_login_form.dart';
import '../widgets/google_login_button.dart';
import '../widgets/login_error_widget.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: DialogOverlayTokens.of(context).barrier,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<AuthBloc>(),
        child: const LoginDialog(),
      ),
    );
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    try {
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      
      if (account == null) {
        return;
      }

      final authentication = await account.authentication;
      
      if (authentication.idToken == null || authentication.accessToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('auth_error_google_signin_failed'.tr()),
            ),
          );
        }
        return;
      }

      if (context.mounted) {
        context.read<AuthBloc>().add(
              AuthEvent.loginWithGoogle(
                idToken: authentication.idToken!,
                accessToken: authentication.accessToken!,
              ),
            );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('auth_error_google_signin_failed'.tr()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tokens = DialogOverlayTokens.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backdropOpacity = isDark
        ? DesignTokens.backdropBlurOpacityDark
        : DesignTokens.backdropBlurOpacityLight;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_) {
            Navigator.of(context).pop();
          },
          error: (failure) {
            if (failure is! NetworkFailure || failure.message.contains('offline')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.message),
                ),
              );
            }
          },
          orElse: () {},
        );
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: DesignTokens.backdropBlurSigma,
              sigmaY: DesignTokens.backdropBlurSigma,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: EdgeInsets.all(DesignTokens.spacingXl),
              decoration: BoxDecoration(
                color: tokens.surface.withValues(
                  alpha: backdropOpacity,
                ),
                borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );

                  return Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'auth_login_title'.tr(),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => Navigator.of(context).pop(),
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                          SizedBox(height: DesignTokens.spacingXl),
                          if (state.maybeWhen(
                            error: (failure) => failure,
                            orElse: () => null,
                          ) != null)
                            LoginErrorWidget(
                              failure: state.maybeWhen(
                                error: (failure) => failure,
                                orElse: () => const UnknownFailure('Unknown error'),
                              )!,
                            ),
                          EmailLoginForm(
                            isLoading: isLoading,
                            onLogin: (email, password) {
                              context.read<AuthBloc>().add(
                                    AuthEvent.loginWithEmail(
                                      email: email,
                                      password: password,
                                    ),
                                  );
                            },
                          ),
                          SizedBox(height: DesignTokens.spacingL),
                          Center(
                            child: Text(
                              'auth_or'.tr(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingL),
                          GoogleLoginButton(
                            onPressed: () => _handleGoogleLogin(context),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

