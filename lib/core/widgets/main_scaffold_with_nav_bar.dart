import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../../features/shopping_list/presentation/providers/shopping_provider.dart';

class MainScaffoldWithNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCount = ref.watch(activeListsCountProvider);
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFF1F5F9),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  index: 0,
                  currentIndex: currentIndex,
                  label: 'Beranda',
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  onTap: () => _onItemTapped(0),
                ),
                _NavBarItem(
                  index: 1,
                  currentIndex: currentIndex,
                  label: 'Daftar',
                  icon: Icons.checklist_rounded,
                  activeIcon: Icons.checklist_rounded,
                  badgeCount: activeCount,
                  onTap: () => _onItemTapped(1),
                ),
                _NavBarItem(
                  index: 2,
                  currentIndex: currentIndex,
                  label: 'Riwayat',
                  icon: Icons.history_rounded,
                  activeIcon: Icons.history_rounded,
                  onTap: () => _onItemTapped(2),
                ),
                _NavBarItem(
                  index: 3,
                  currentIndex: currentIndex,
                  label: 'Profil',
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  onTap: () => _onItemTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final color = isSelected ? AppColors.primary : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: color,
                  size: 24,
                ),
                // Badge angka orange jika ada (seperti angka 3 pada tab Daftar)
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.orangePrimary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

