import 'package:flutter/material.dart';

class FiltersWidget extends StatefulWidget {
  @override
  _FiltersWidgetState createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  final Map<String, List<String>> filterOptions = {
    'Top Searches': ['Trending', 'Popular', 'New', 'Most Viewed'],
    'Regions': ['Asia', 'Europe', 'America', 'Africa', 'Australia', 'Canada'],
    'Genres': ['Action', 'Drama', 'Comedy', 'Romance', 'Horror', 'Fiction'],
    'Time/Period': ['Last Week', 'Last Month', 'Last Year'],
    'Sort': ['Ascending', 'Descending'],
  };

  final Map<String, String?> selectedFilters = {};

  void toggleSelection(String category, String option) {
    setState(() {
      if (selectedFilters[category] == option) {
        selectedFilters[category] = null;
      } else {
        selectedFilters[category] = option;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 175, 175),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Sort and Filter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...filterOptions.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: entry.value.map((option) {
                    final isSelected = selectedFilters[entry.key] == option;
                    return ChoiceChip(
                      label: Text(option,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.red)),
                      selected: isSelected,
                      onSelected: (_) => toggleSelection(entry.key, option),
                      selectedColor: Colors.red,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    selectedFilters.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Reset", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, selectedFilters),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child:
                    const Text("Apply", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Function to show the modal bottom sheet
void showFilters(BuildContext context) {
  showModalBottomSheet(
    sheetAnimationStyle:
        AnimationStyle(curve: Curves.bounceIn, duration: Duration(seconds: 3)),
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => FiltersWidget(),
  );
}
