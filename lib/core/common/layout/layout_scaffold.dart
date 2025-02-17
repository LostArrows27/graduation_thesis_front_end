import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/destination.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                );
              }
              return TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              );
            },
          ),
        ),
        child: NavigationBar(
          animationDuration: const Duration(milliseconds: 0),
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          destinations: List.generate(destinations.length, (i) {
            final dest = destinations[i];
            final bool isSelected = i == navigationShell.currentIndex;
            return NavigationDestination(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  firstChild: Icon(
                    dest.icon,
                    key: ValueKey('unselected_${dest.label}'),
                    color:
                        Theme.of(context).colorScheme.onSecondaryFixedVariant,
                  ),
                  secondChild: Icon(
                    dest.selectedIcon,
                    key: ValueKey('selected_${dest.label}'),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  crossFadeState: isSelected
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
