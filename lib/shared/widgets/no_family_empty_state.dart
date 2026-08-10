import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';
import '../../l10n/app_localizations.dart';
import 'empty_state.dart';

/// Kullanıcı henüz bir eve / aileye dahil olmadığında gösterilen Empty State / CTA bileşeni.
class NoFamilyEmptyState extends StatelessWidget {
  const NoFamilyEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: Icons.home_work_outlined,
      title: l10n.notMemberOfHomeYet,
      description: l10n.noHomeSyncDesc,
      actionLabel: l10n.createOrJoinHome,
      actionIcon: Icons.add_home_outlined,
      onActionPressed: () {
        context.go(AppRoutes.profile);
      },
    );
  }
}
