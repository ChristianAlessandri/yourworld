import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:yourworld/core/constants/app_colors.dart';
import 'package:yourworld/models/country.dart';
import 'package:yourworld/models/country_status.dart';

class DetailListScreen extends StatelessWidget {
  final String title;
  final List<String> allItems;
  final Set<String> visitedItems;
  final Map<String, List<Country>> groupedCountries;

  const DetailListScreen({
    super.key,
    required this.title,
    required this.allItems,
    required this.visitedItems,
    required this.groupedCountries,
  });

  @override
  Widget build(BuildContext context) {
    final total = allItems.length;
    final visited = visitedItems.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(FluentIcons.chevron_left_20_filled,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '$visited / $total visited',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allItems.length,
              itemBuilder: (_, index) {
                final key = allItems[index];
                final isVisited = visitedItems.contains(key);
                final countries = groupedCountries[key] ?? [];
                final sortedCountries = [...countries]
                  ..sort((a, b) => a.name.compareTo(b.name));

                return ExpansionTile(
                  title: Text(
                    key,
                    style: TextStyle(
                      fontWeight:
                          isVisited ? FontWeight.bold : FontWeight.normal,
                      color: isVisited
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  children: sortedCountries.map((c) {
                    final statusText = () {
                      switch (c.status) {
                        case CountryStatus.visited:
                          return 'Visited';
                        case CountryStatus.lived:
                          return 'Lived';
                        case CountryStatus.want:
                          return 'Want';
                        default:
                          return 'None';
                      }
                    }();

                    return ListTile(
                      title: Text(c.name),
                      subtitle: Text(statusText),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
