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

    final selected = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _SearchableOptionsContent<T>(
          title: title,
          options: options,
          searchHint: searchHint,
          helperText: helperText,
          emptyStateText: emptyStateText,
          closeTooltip: closeTooltip,
          selectedValue: selectedValue,
          resolveLabel: resolveLabel,
          resolveSearchText: resolveSearchText,
        );
      },
    );

    return selected;
  }
}

class _SearchableOptionsContent<T> extends StatefulWidget {
  const _SearchableOptionsContent({
    Key? key,
    required this.title,
    required this.options,
    required this.searchHint,
    required this.helperText,
    required this.emptyStateText,
    required this.closeTooltip,
    this.selectedValue,
    required this.resolveLabel,
    required this.resolveSearchText,
  }) : super(key: key);

  final String title;
  final List<T> options;
  final String searchHint;
  final String helperText;
  final String emptyStateText;
  final String closeTooltip;
  final T? selectedValue;
  final String Function(T) resolveLabel;
  final String Function(T) resolveSearchText;

  @override
  State<_SearchableOptionsContent<T>> createState() =>
      _SearchableOptionsContentState<T>();
}

class _SearchableOptionsContentState<T>
    extends State<_SearchableOptionsContent<T>> {
  late List<T> filteredOptions;
  late final TextEditingController searchController;
  late final FocusNode searchFocus;

  @override
  void initState() {
    super.initState();
    filteredOptions = List<T>.from(widget.options);
    searchController = TextEditingController();
    searchFocus = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        FocusScope.of(context).requestFocus(searchFocus);
      } catch (_) {
        // ignore any focus errors
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    var availableHeight = media.size.height * 0.72 - media.viewInsets.bottom;
    if (availableHeight < 200) availableHeight = media.size.height * 0.5;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: media.viewInsets.bottom + 16,
        ),
        child: SizedBox(
          height: availableHeight,
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
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: widget.closeTooltip,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.helperText,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: searchController,
                focusNode: searchFocus,
                onChanged: (query) {
                  final normalizedQuery = query.toLowerCase();
                  setState(() {
                    filteredOptions = widget.options
                        .where((item) => widget
                            .resolveSearchText(item)
                            .toLowerCase()
                            .contains(normalizedQuery))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  hintText: widget.searchHint,
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
                              widget.emptyStateText,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(top: 4),
                        itemCount: filteredOptions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = filteredOptions[index];
                          final isSelected = item == widget.selectedValue;
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tileColor: isSelected
                                ? AppColors.primary.withValues(alpha: 0.10)
                                : null,
                            title: Text(
                              widget.resolveLabel(item),
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
                            onTap: () => Navigator.of(context).pop(item),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
