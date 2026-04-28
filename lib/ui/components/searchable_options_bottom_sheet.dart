import 'package:flutter/material.dart';

import '../helpers/themes/app_colors.dart';

class SearchableOptionsBottomSheet {
  SearchableOptionsBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> options,
    required String searchHint,
    required String helperText,
    required String emptyStateText,
    required String closeTooltip,
    T? selectedValue,
    String Function(T item)? labelBuilder,
    String Function(T item)? searchTextBuilder,
  }) async {
    final resolveLabel = labelBuilder ?? (T item) => item.toString();
    final resolveSearchText = searchTextBuilder ?? resolveLabel;

    final searchController = TextEditingController();
    var filteredOptions = List<T>.from(options);

    final selected = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: closeTooltip,
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        helperText,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: searchController,
                        onChanged: (query) {
                          final normalizedQuery = query.toLowerCase();
                          setModalState(() {
                            filteredOptions = options
                                .where(
                                  (item) => resolveSearchText(item)
                                      .toLowerCase()
                                      .contains(normalizedQuery),
                                )
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: searchHint,
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filteredOptions.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      color: Colors.grey.shade400,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      emptyStateText,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.only(top: 4),
                                itemCount: filteredOptions.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final item = filteredOptions[index];
                                  final isSelected = item == selectedValue;
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor: isSelected
                                        ? AppColors.primary
                                            .withValues(alpha: 0.10)
                                        : null,
                                    title: Text(
                                      resolveLabel(item),
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: AppColors.primary,
                                          )
                                        : null,
                                    onTap: () =>
                                        Navigator.of(context).pop(item),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    searchController.dispose();
    return selected;
  }
}
