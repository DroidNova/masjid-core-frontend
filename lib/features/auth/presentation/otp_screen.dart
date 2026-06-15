import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_core_frontend/features/auth/data/auth_repository.dart';
import 'package:platform_core_frontend/shared/widgets/app_button.dart';
import 'package:platform_core_frontend/shared/widgets/app_text_field.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.phone,
    required this.challengeId,
    AuthRepository? authRepository,
  }) : _authRepository = authRepository;

  final String phone;
  final String challengeId;
  final AuthRepository? _authRepository;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  late final AuthRepository _authRepository =
      widget._authRepository ?? AuthRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _showError('Please enter the OTP.');
      return;
    }

    if (otp.length != 6) {
      _showError('OTP must be 6 digits.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.verifyOtp(widget.phone, widget.challengeId, otp);

      if (!mounted) return;

      context.go('/main');
    } catch (error) {
      if (mounted) _showError(_cleanError(error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Verify OTP',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the 6 digit OTP',
                    style: textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For testing use 111111',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _otpController,
                    label: 'OTP',
                    hint: '111111',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Verify',
                    isLoading: _isLoading,
                    onPressed: _verify,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Back',
                    isOutlined: true,
                    onPressed: () => context.go('/login-phone'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
