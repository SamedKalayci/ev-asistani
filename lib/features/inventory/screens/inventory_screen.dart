import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/no_family_empty_state.dart';
import '../../expiration/screens/expiration_screen.dart';
import '../../vault/screens/vault_screen.dart';
import '../../warranty/screens/warranty_screen.dart';

/// Envanter sekmelerinin (0: Son Kullanma, 1: Garantiler, 2: Kasası) durumunu yöneten provider.
final inventoryTabProvider = StateProvider<int>((ref) => 0);

/// Envanter Ana Ekranı — 3'lü Top TabBar ile Son Kullanma, Garantiler ve Ev Kasası'nı tek ekranda birleştirir.
class InventoryScreen extends ConsumerStatefulWidget {
  /// Başlangıç sekme indeksi (0: Son Kullanma, 1: Garantiler, 2: Kasası)
  final int initialTabIndex;

  const InventoryScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // widget.initialTabIndex ile geldiyse (home'dan deep-nav), onu esas al
    final startIndex = widget.initialTabIndex.clamp(0, 2);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: startIndex,
    );
    // Provider'ı post-frame'de güncelle (initState içinde state yazılamaz)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(inventoryTabProvider.notifier).state = startIndex;
      }
    });
    _tabController.addListener(() {
      if (mounted && _tabController.indexIsChanging) {
        ref.read(inventoryTabProvider.notifier).state = _tabController.index;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFamily = ref.watch(hasRealFamilyProvider);
    final currentTab = ref.watch(inventoryTabProvider);

    if (_tabController.index != currentTab) {
      _tabController.animateTo(currentTab.clamp(0, 2));
    }

    final l10n = AppLocalizations.of(context)!;

    if (!hasFamily) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppHeader(title: l10n.appName),
        body: const SafeArea(child: NoFamilyEmptyState()),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: l10n.appName,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, // 16 yerine 12px padding ile daha geniş alan
              vertical: AppSpacing.xs,
            ),
            child: _buildTopTabBar(colorScheme),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ExpirationTabView(),
          _WarrantyTabView(),
          VaultScreen(),
        ],
      ),
    );
  }

  // ── Soft 3'lü Segmented TabBar (Taşmasız Ekran Uyumlu) ─────────────────────
  Widget _buildTopTabBar(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.7),
        borderRadius: AppRadius.borderFull,
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        indicator: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: AppRadius.borderFull,
          boxShadow: AppShadows.xs,
        ),
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        tabs: [
          Tab(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(l10n.expirationTab),
            ),
          ),
          Tab(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(l10n.warrantyTab),
            ),
          ),
          Tab(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                l10n.vaultTab,
                style: const TextStyle(
                  color: Color(0xFF006E28),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── TabView Katmanları ───────────────────────────────────────────────────────

class _ExpirationTabView extends StatelessWidget {
  const _ExpirationTabView();

  @override
  Widget build(BuildContext context) {
    return const ExpirationScreen();
  }
}

class _WarrantyTabView extends StatelessWidget {
  const _WarrantyTabView();

  @override
  Widget build(BuildContext context) {
    return const WarrantyScreen();
  }
}
