import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/destination.dart';
import 'package:graduation_thesis_front_end/core/utils/show_add_modal.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    const int addIndex = 2;
    final int selectedIndex = navigationShell.currentIndex < addIndex
        ? navigationShell.currentIndex
        : navigationShell.currentIndex + 1;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Theme.of(context).colorScheme.primaryFixedDim,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                );
              }
              return TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              );
            },
          ),
        ),
        child: NavigationBar(
          animationDuration: const Duration(milliseconds: 0),
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            if (index == addIndex) {
              showAddModal(context);
            } else {
              final int branchIndex = index < addIndex ? index : index - 1;
              navigationShell.goBranch(branchIndex);
            }
          },
          destinations: List.generate(destinations.length, (i) {
            final dest = destinations[i];

            return NavigationDestination(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  firstChild: Icon(
                    dest.icon,
                    size: i == addIndex ? 30 : 24,
                    key: ValueKey('unselected_${dest.label}'),
                    color: i == addIndex
                        ? Theme.of(context).colorScheme.primaryFixedDim
                        : Theme.of(context).colorScheme.outline,
                  ),
                  secondChild: Icon(
                    dest.selectedIcon,
                    key: ValueKey('selected_${dest.label}'),
                  ),
                  crossFadeState: i == selectedIndex
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
              ),
              label: dest.label,
              tooltip: null,
            );
          }),
        ),
      ),
    );
  }
}
