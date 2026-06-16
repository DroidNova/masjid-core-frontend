import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_core_frontend/core/auth/current_user_role_helper.dart';
import 'package:platform_core_frontend/core/storage/session_storage.dart';
import 'package:platform_core_frontend/features/auth/data/auth_repository.dart';
import 'package:platform_core_frontend/features/auth/data/models/app_user.dart';
import 'package:platform_core_frontend/features/community/data/community_repository.dart';
import 'package:platform_core_frontend/features/community/data/models/community_user_model.dart';
import 'package:platform_core_frontend/features/community/data/models/masjid_detail_model.dart';
import 'package:platform_core_frontend/features/community/presentation/widgets/community_section.dart';
import 'package:platform_core_frontend/features/community/presentation/widgets/masjid_info_card.dart';
import 'package:platform_core_frontend/shared/widgets/app_button.dart';
import 'package:platform_core_frontend/shared/widgets/loading_view.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({
    super.key,
    CommunityRepository? communityRepository,
    AuthRepository? authRepository,
    SessionStorage? sessionStorage,
  })  : _communityRepository = communityRepository,
        _authRepository = authRepository,
        _sessionStorage = sessionStorage;

  final CommunityRepository? _communityRepository;
  final AuthRepository? _authRepository;
  final SessionStorage? _sessionStorage;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late final CommunityRepository _communityRepository =
      widget._communityRepository ?? CommunityRepository();
  late final AuthRepository _authRepository =
      widget._authRepository ?? AuthRepository();
  late final SessionStorage _sessionStorage =
      widget._sessionStorage ?? SessionStorage();

  MasjidDetailModel? _masjid;
  List<CommunityUserModel> _users = <CommunityUserModel>[];
  String? _errorMessage;
  bool _isLoading = true;
  AppUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadCommunity();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _sessionStorage.getUser();
    if (!mounted) return;
    setState(() => _currentUser = user);
  }

  Future<void> _loadCommunity() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final results = await Future.wait<Object>([
        _communityRepository.getMyMasjid(),
        _communityRepository.getMyMasjidUsers(),
      ]);
      if (!mounted) return;
      setState(() {
        _masjid = results[0] as MasjidDetailModel;
        _users = results[1] as List<CommunityUserModel>;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _cleanError(error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshCommunity() async {
    try {
      final results = await Future.wait<Object>([
        _communityRepository.getMyMasjid(),
        _communityRepository.getMyMasjidUsers(),
      ]);
      if (!mounted) return;
      setState(() {
        _masjid = results[0] as MasjidDetailModel;
        _users = results[1] as List<CommunityUserModel>;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _cleanError(error));
    }
  }

  Future<void> _logout() async {
    await _authRepository.logout();
    if (!mounted) return;
    context.go('/auth');
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  bool get _isUnauthorizedError {
    final message = _errorMessage?.toLowerCase() ?? '';
    return message.contains('unauthorized') || message.contains('401');
  }

  bool get _isNoMasjidError {
    final message = _errorMessage?.toLowerCase() ?? '';
    return message.contains('not assigned') || message.contains('masjid');
  }

  bool get _canAddUsers {
    final user = _currentUser;
    return user != null && CurrentUserRoleHelper.canAddUsers(user);
  }

  Future<void> _openAddUser() async {
    await context.push('/community/add-user');
    await _loadCurrentUser();
    await _refreshCommunity();
  }

  List<CommunityUserModel> get _committeeUsers {
    return _users
        .where((user) => user.isMasjidAdmin || user.isCommitteeMember)
        .toList();
  }

  List<CommunityUserModel> get _imamUsers {
    return _users
        .where(
          (user) =>
              user.isImam && !user.isMasjidAdmin && !user.isCommitteeMember,
        )
        .toList();
  }

  List<CommunityUserModel> get _memberUsers {
    final groupedIds = <String>{
      ..._committeeUsers.map((user) => user.id),
      ..._imamUsers.map((user) => user.id),
    };
    return _users.where((user) => !groupedIds.contains(user.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const LoadingView();

    if (_errorMessage != null) {
      if (_isUnauthorizedError) {
        return _CommunityErrorView(
          message: 'Session expired. Please login again.',
          buttonLabel: 'Back to Login',
          onPressed: _logout,
        );
      }
      return _CommunityErrorView(
        message: _isNoMasjidError
            ? 'You are not assigned to any masjid yet.'
            : 'Unable to load community details.',
        detail: _isNoMasjidError ? null : _errorMessage,
        onPressed: _loadCommunity,
      );
    }

    final masjid = _masjid;
    if (masjid == null) {
      return _CommunityErrorView(
        message: 'Unable to load community details.',
        onPressed: _loadCommunity,
      );
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshCommunity,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Community',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text('Masjid members and committee details'),
                    if (_canAddUsers) ...<Widget>[
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FilledButton.icon(
                          onPressed: _openAddUser,
                          icon: const Icon(Icons.person_add_alt_1),
                          label: const Text('Add User'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    MasjidInfoCard(masjid: masjid),
                    const SizedBox(height: 12),
                    CommunitySection(
                      title: 'Imam',
                      users: _imamUsers,
                      emptyMessage: 'Imam is not added yet.',
                    ),
                    const SizedBox(height: 12),
                    CommunitySection(
                      title: 'Committee Members',
                      users: _committeeUsers,
                      emptyMessage: 'No committee members added yet.',
                    ),
                    const SizedBox(height: 12),
                    CommunitySection(
                      title: 'Members',
                      users: _memberUsers,
                      emptyMessage: 'No members added yet.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityErrorView extends StatelessWidget {
  const _CommunityErrorView({
    required this.message,
    required this.onPressed,
    this.detail,
    this.buttonLabel = 'Retry',
  });

  final String message;
  final String? detail;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.groups_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (detail != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(detail!, textAlign: TextAlign.center),
                ],
                const SizedBox(height: 20),
                AppButton(label: buttonLabel, onPressed: onPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
