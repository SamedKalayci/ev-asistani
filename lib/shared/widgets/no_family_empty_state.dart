import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';
import 'empty_state.dart';

/// Kullanıcı henüz bir eve / aileye dahil olmadığında gösterilen Empty State / CTA bileşeni.
class NoFamilyEmptyState extends StatelessWidget {
  const NoFamilyEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.home_work_outlined,
      title: 'Henüz Bir Eve Dahil Değilsiniz',
      description:
          'Henüz bir eve dahil değilsiniz. Bir ev oluşturun veya davet koduyla katılın.',
      actionLabel: 'Ev Oluştur veya Katıl',
      actionIcon: Icons.add_home_outlined,
      onActionPressed: () {
        context.go(AppRoutes.profile);
      },
    );
  }
}
