import 'package:flutter/material.dart';

class TestSearchBar extends StatefulWidget {
  const TestSearchBar({
    super.key,
    this.explain = false,
    this.isFullScreen = false,
  });
  final bool explain;
  final bool isFullScreen;

  @override
  State<TestSearchBar> createState() => _TestSearchBarState();
}

class _TestSearchBarState extends State<TestSearchBar> {
  bool isMicOn = false;
  String? selectedColor;
  List<_ColorItem> searchHistory = <_ColorItem>[];

  Iterable<Widget> getHistoryList(SearchController controller) {
    return searchHistory.map((_ColorItem color) => ListTile(
          leading: const Icon(Icons.history),
          title: Text(color.label),
          trailing: IconButton(
              icon: const Icon(Icons.call_missed),
              onPressed: () {
                controller.text = color.label;
                controller.selection =
                    TextSelection.collapsed(offset: controller.text.length);
              }),
          onTap: () {
            controller.closeView(color.label);
            handleSelection(color);
          },
        ));
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
    return _ColorItem.values
        .where((_ColorItem color) => color.label.contains(input))
        .map((_ColorItem filteredColor) => ListTile(
              leading: CircleAvatar(backgroundColor: filteredColor.color),
              title: Text(filteredColor.label),
              trailing: IconButton(
                  icon: const Icon(Icons.call_missed),
                  onPressed: () {
                    controller.text = filteredColor.label;
                    controller.selection =
                        TextSelection.collapsed(offset: controller.text.length);
                  }),
              onTap: () {
                controller.closeView(filteredColor.label);
                handleSelection(filteredColor);
              },
            ));
  }

  void handleSelection(_ColorItem color) {
    setState(() {
      selectedColor = color.label;
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, color);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle denseHeader = theme.textTheme.titleMedium!.copyWith(
      fontSize: 13,
    );
    final TextStyle denseBody = theme.textTheme.bodyMedium!
        .copyWith(fontSize: 12, color: theme.textTheme.bodySmall!.color);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.explain) ...<Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  'SearchBar',
                  style: denseHeader,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text(
                  'The M3 SearchBar can in some use cases be used instead '
                  'of an AppBar or BottomAppBar.',
                  style: denseBody,
                ),
              ),
            ],
            SearchAnchor.bar(
              isFullScreen: widget.isFullScreen,
              barHintText: 'Search colors',
              barTrailing: <Widget>[
                Tooltip(
                  message: 'Voice search',
                  child: IconButton(
                    isSelected: isMicOn,
                    onPressed: () {
                      setState(() {
                        isMicOn = !isMicOn;
                      });
                    },
                    icon: const Icon(Icons.mic_off),
                    selectedIcon: const Icon(Icons.mic),
                  ),
                )
              ],
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                if (controller.text.isEmpty) {
                  if (searchHistory.isNotEmpty) {
                    return getHistoryList(controller);
                  }
                  return <Widget>[
                    const Center(
                      child: Text('No search history.',
                          style: TextStyle(color: Colors.grey)),
                    )
                  ];
                }
                return getSuggestions(controller);
              },
            ),
            const SizedBox(height: 20),
            if (selectedColor == null)
              const Text('Select a color')
            else
              Text('Last selected color is $selectedColor')
          ],
        ),
      ),
    );
  }
}

enum _ColorItem {
  red('red', Colors.red),
  orange('orange', Colors.orange),
  yellow('yellow', Colors.yellow),
  green('green', Colors.green),
  blue('blue', Colors.blue),
  indigo('indigo', Colors.indigo),
  violet('violet', Color(0xFF8F00FF)),
  purple('purple', Colors.purple),
  pink('pink', Colors.pink),
  silver('silver', Color(0xFF808080)),
  gold('gold', Color(0xFFFFD700)),
  beige('beige', Color(0xFFF5F5DC)),
  brown('brown', Colors.brown),
  grey('grey', Colors.grey),
  black('black', Colors.black),
  peach('peach', Color(0xFFFFE5B4)),
  cream('cream', Color(0xFFFFFDD0)),
  aquamarine('aquamarine', Color(0xFF7FFFD4)),
  seagull('seagull', Color(0xFF80CCEA)),
  redDevil('red devil', Color(0xFF860111)),
  blueStone('blue stone', Color(0xFF016162)),
  cerulean('cerulean', Color(0xFF02A4D3)),
  tangaroa('tangaroa', Color(0xFF03163C)),
  zuccini('zuccini', Color(0xFF044022)),
  firefly('firefly', Color(0xFF0E2A30)),
  java('java', Color(0xFF1FC2C2)),
  graphite('graphite', Color(0xFF251607)),
  mariner('mariner', Color(0xFF286ACD)),
  aubergine('aubergine', Color(0xFF3B0910)),
  horizon('horizon', Color(0xFF5A87A0)),
  bordeaux('bordeaux', Color(0xFF5C0120)),
  redwood('redwood', Color(0xFF5D1E0F)),
  espresso('espresso', Color(0xFF612718)),
  eggplant('eggplant', Color(0xFF614051)),
  walnut('walnut', Color(0xFF773F1A)),
  maroon('maroon', Color(0xFF800000)),
  faluRed('falu red', Color(0xFF801818)),
  amethyst('amethyst', Color(0xFF9966CC)),
  sage('sage', Color(0xFF9EA587)),
  rouge('rouge', Color(0xFFA23B6C)),
  fire('fire', Color(0xFFAA4203)),
  lipstick('lipstick', Color(0xFFAB0563)),
  bronco('bronco', Color(0xFFABA196)),
  cadillac('cadillac', Color(0xFFB04C6A)),
  padua('padua', Color(0xFFADE6C4)),
  desert('desert', Color(0xFFAE6020)),
  bouquet('bouquet', Color(0xFFAE809E)),
  hippiePink('hippie pink', Color(0xFFAE4560)),
  hibiscus('hibiscus', Color(0xFFB6316C)),
  rust('rust', Color(0xFFB7410E)),
  sahara('sahara', Color(0xFFB7A214)),
  bourbon('bourbon', Color(0xFFBA6F1E)),
  grenadier('grenadier', Color(0xFFD54600)),
  white('white', Colors.white);

  const _ColorItem(this.label, this.color);
  final String label;
  final Color color;
}
