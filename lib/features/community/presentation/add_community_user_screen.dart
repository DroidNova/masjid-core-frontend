import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_core_frontend/core/auth/current_user_role_helper.dart';
import 'package:platform_core_frontend/core/storage/session_storage.dart';
import 'package:platform_core_frontend/core/storage/token_storage.dart';
import 'package:platform_core_frontend/features/auth/data/models/app_user.dart';
import 'package:platform_core_frontend/features/community/data/community_repository.dart';
import 'package:platform_core_frontend/features/community/data/models/create_community_user_request.dart';
import 'package:platform_core_frontend/features/community/data/models/community_user_model.dart';
import 'package:platform_core_frontend/features/community/presentation/widgets/add_user_role_dropdown.dart';
import 'package:platform_core_frontend/shared/widgets/app_button.dart';
import 'package:platform_core_frontend/shared/widgets/loading_view.dart';

class AddCommunityUserScreen extends StatefulWidget {
  const AddCommunityUserScreen({
    super.key,
    CommunityRepository? communityRepository,
    SessionStorage? sessionStorage,
    TokenStorage? tokenStorage,
  })  : _communityRepository = communityRepository,
        _sessionStorage = sessionStorage,
        _tokenStorage = tokenStorage;

  final CommunityRepository? _communityRepository;
  final SessionStorage? _sessionStorage;
  final TokenStorage? _tokenStorage;

  @override
  State<AddCommunityUserScreen> createState() => _AddCommunityUserScreenState();
}

class _AddCommunityUserScreenState extends State<AddCommunityUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _masjidIdController = TextEditingController();

  late final CommunityRepository _communityRepository =
      widget._communityRepository ?? CommunityRepository();
  late final SessionStorage _sessionStorage =
      widget._sessionStorage ?? SessionStorage();
  late final TokenStorage _tokenStorage = widget._tokenStorage ?? TokenStorage();

  AppUser? _currentUser;
  List<String> _allowedRoles = const <String>[];
  String? _selectedRole;
  bool _isLoadingUser = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _sessionStorage.getUser();
    if (!mounted) return;
    final allowedRoles = user == null
        ? const <String>[]
        : CurrentUserRoleHelper.allowedRolesToCreate(user);
    setState(() {
      _currentUser = user;
      _allowedRoles = allowedRoles;
      _selectedRole = allowedRoles.isEmpty ? null : allowedRoles.first;
      _isLoadingUser = false;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _masjidIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final createdUser = await _communityRepository.createMasjidUser(
        CreateCommunityUserRequest(
          fullName: _fullNameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          role: _selectedRole!,
          masjidId: _masjidIdController.text,
        ),
      );

      if (!mounted) return;
      await _showSuccess(createdUser);
      if (mounted) context.pop(true);
    } catch (error) {
      if (!mounted) return;
      await _handleError(error);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _showSuccess(CommunityUserModel createdUser) async {
    final message = _successMessage(createdUser);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Added'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _successMessage(CommunityUserModel user) {
    if (user.message != null && user.message!.isNotEmpty) return user.message!;
    if (user.temporaryPassword != null && user.temporaryPassword!.isNotEmpty) {
      return 'User added successfully. Temporary password is ${user.temporaryPassword}.';
    }
    if (_selectedRole == CurrentUserRoleHelper.member) {
      return 'Member added successfully. This user can login using phone OTP.';
    }
    return 'User added successfully.';
  }

  Future<void> _handleError(Object error) async {
    final message = _friendlyErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    final lower = error.toString().toLowerCase();
    if (lower.contains('unauthorized') || lower.contains('401')) {
      await _tokenStorage.clearTokens();
      await _sessionStorage.clearUser();
      if (mounted) context.go('/auth');
    }
  }

  String _friendlyErrorMessage(Object error) {
    final lower = error.toString().toLowerCase();
    if (lower.contains('unauthorized') || lower.contains('401')) {
      return 'Session expired. Please login again.';
    }
    if (lower.contains('not assigned') && lower.contains('masjid')) {
      return 'You are not assigned to any masjid yet.';
    }
    if (lower.contains('phone') &&
        (lower.contains('exists') || lower.contains('duplicate'))) {
      return 'Phone number already exists.';
    }
    if (lower.contains('email') &&
        (lower.contains('exists') || lower.contains('duplicate'))) {
      return 'Email already exists.';
    }
    if (lower.contains('forbidden') || lower.contains('403')) {
      return 'You are not allowed to add this role.';
    }
    return 'Unable to add user.';
  }

  bool get _shouldShowMasjidIdField {
    final user = _currentUser;
    if (user == null) return false;
    return CurrentUserRoleHelper.hasRole(
          user,
          CurrentUserRoleHelper.superAdmin,
        ) &&
        (user.masjidId == null || user.masjidId!.trim().isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) return const LoadingView();

    return Scaffold(
      appBar: AppBar(title: const Text('Add User')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: _allowedRoles.isEmpty ? _notAllowedView(context) : _form(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notAllowedView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(
          Icons.lock_outline,
          size: 56,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'You are not allowed to add users.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        AppButton(label: 'Back', onPressed: () => context.pop()),
      ],
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Add User',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          const Text('Create a user for your masjid community.'),
          const SizedBox(height: 24),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter full name.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone *',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (value) {
              final phone = value?.trim() ?? '';
              if (phone.isEmpty) return 'Please enter phone number.';
              if (phone.length < 10) {
                return 'Phone number must be at least 10 digits.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email optional',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isNotEmpty && !email.contains('@')) {
                return 'Please enter a valid email.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AddUserRoleDropdown(
            allowedRoles: _allowedRoles,
            value: _selectedRole,
            onChanged: (role) => setState(() => _selectedRole = role),
          ),
          if (_shouldShowMasjidIdField) ...<Widget>[
            const SizedBox(height: 16),
            TextFormField(
              controller: _masjidIdController,
              decoration: const InputDecoration(
                labelText: 'Masjid ID',
                helperText:
                    'Required only for super admin when not assigned to a masjid.',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: AppButton(
              label: 'Save User',
              isLoading: _isSaving,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
