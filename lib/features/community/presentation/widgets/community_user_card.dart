import 'package:flutter/material.dart';
import 'package:platform_core_frontend/features/community/data/models/community_user_model.dart';

class CommunityUserCard extends StatelessWidget {
  const CommunityUserCard({super.key, required this.user});

  final CommunityUserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person_outline),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(user.primaryRoleLabel),
            if (user.phone != null) Text('Phone: ${user.phone}'),
            if (user.email != null) Text('Email: ${user.email}'),
            if (user.status != null) Text('Status: ${user.status}'),
          ],
        ),
      ),
    );
  }
}
