import 'package:flutter/material.dart';

class ColumnSelector extends StatelessWidget {
  final String tooltip;
  final List<ColumnOption> allColumns;
  final Set<String> selectedKeys;
  final ValueChanged<Set<String>> onChanged;

  const ColumnSelector({
    super.key,
    this.tooltip = 'Select columns',
    required this.allColumns,
    required this.selectedKeys,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: tooltip,
      icon: Icon(
        Icons.view_column_outlined,
        size: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onSelected: (key) {
        final next = Set<String>.from(selectedKeys);
        if (next.contains(key)) {
          if (next.length > 1) next.remove(key);
        } else {
          next.add(key);
        }
        onChanged(next);
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            enabled: false,
            child: Text(
              'Toggle Columns',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const PopupMenuDivider(),
          ...allColumns.map((col) {
            final isSelected = selectedKeys.contains(col.key);
            return PopupMenuItem<String>(
              value: col.key,
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 18,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(col.label)),
                ],
              ),
            );
          }),
        ];
      },
    );
  }
}

class ColumnOption {
  final String key;
  final String label;

  const ColumnOption({required this.key, required this.label});
}
