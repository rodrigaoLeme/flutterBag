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
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SearchableBottomSheetContent<T>(
        title: title,
        options: options,
        searchHint: searchHint,
        helperText: helperText,
        emptyStateText: emptyStateText,
        closeTooltip: closeTooltip,
        selectedValue: selectedValue,
        labelBuilder: labelBuilder,
        searchTextBuilder: searchTextBuilder,
      ),
    );
  }
}

class _SearchableBottomSheetContent<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final String searchHint;
  final String helperText;
  final String emptyStateText;
  final String closeTooltip;
  final T? selectedValue;
  final String Function(T item)? labelBuilder;
  final String Function(T item)? searchTextBuilder;

  const _SearchableBottomSheetContent({
    required this.title,
    required this.options,
    required this.searchHint,
    required this.helperText,
    required this.emptyStateText,
    required this.closeTooltip,
    this.selectedValue,
    this.labelBuilder,
    this.searchTextBuilder,
  });

  @override
  State<_SearchableBottomSheetContent<T>> createState() =>
      _SearchableBottomSheetContentState<T>();
}

class _SearchableBottomSheetContentState<T>
    extends State<_SearchableBottomSheetContent<T>> {
  late final TextEditingController _searchController;
  late List<T> _filteredOptions;

  late final String Function(T) _resolveLabel;
  late final String Function(T) _resolveSearchText;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredOptions = List<T>.from(widget.options);
    _resolveLabel = widget.labelBuilder ?? (T item) => item.toString();
    _resolveSearchText = widget.searchTextBuilder ?? _resolveLabel;
  }

  @override
  void dispose() {
    _searchController.dispose(); // ← dispose no momento certo
    super.dispose();
  }

  void _onSearch(String query) {
    final normalized = query.toLowerCase();
    setState(() {
      _filteredOptions = widget.options
          .where((item) =>
              _resolveSearchText(item).toLowerCase().contains(normalized))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                onChanged: _onSearch,
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
                child: _filteredOptions.isEmpty
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
                        itemCount: _filteredOptions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = _filteredOptions[index];
                          final isSelected = item == widget.selectedValue;
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tileColor: isSelected
                                ? AppColors.primary.withValues(alpha: 0.10)
                                : null,
                            title: Text(
                              _resolveLabel(item),
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
