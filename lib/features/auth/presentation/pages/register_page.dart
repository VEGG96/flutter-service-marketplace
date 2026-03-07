import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<AuthBloc>().add(
      SignUpRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(state.message),
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Crear cuenta')),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (BuildContext context, AuthState state) {
                    final bool isLoading = state is AuthSubmitting;

                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            AppConstants.appName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Crea tu cuenta para comenzar',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: Validators.email,
                            decoration: const InputDecoration(
                              labelText: 'Correo',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: Validators.password,
                            decoration: InputDecoration(
                              labelText: 'Contrasena',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String? value) {
                              return Validators.confirmPassword(
                                value,
                                password: _passwordController.text,
                              );
                            },
                            onFieldSubmitted: (_) => _onSignUpPressed(),
                            decoration: InputDecoration(
                              labelText: 'Confirmar contrasena',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            label: 'Crear cuenta',
                            icon: Icons.person_add_alt_1_rounded,
                            isLoading: isLoading,
                            onPressed: _onSignUpPressed,
                          ),
                          const SizedBox(height: 14),
                          if (state is AuthError)
                            ErrorBanner(message: state.message),
                          const SizedBox(height: 14),
                          AppOutlinedButton(
                            label: 'Ya tengo cuenta',
                            icon: Icons.login_rounded,
                            onPressed: () => context.go(AppRoutes.login),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
