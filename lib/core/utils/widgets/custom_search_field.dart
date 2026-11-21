import 'package:field_notes/core/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomSearchField({super.key, this.hintText = 'Search', this.onChanged, this.onClear});

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) => _buildClearButton(value.text.isNotEmpty, colorScheme),
        ),
        fillColor: colorScheme.surfaceContainerLowest,
        hintText: widget.hintText,
        border: InputBorder.none,
        isDense: true,
      ),
    );
  }

  Widget _buildClearButton(bool hasValue, ColorScheme colorScheme) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 180),
    transitionBuilder: (child, animation) => FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: animation, child: child),
    ),
    child: hasValue
        ? IconButton(
            key: ValueKey('clear_btn'),
            onPressed: _handleClear,
            tooltip: 'Clear search',
            icon: Icon(Icons.close_rounded, size: 18, color: colorScheme.outline),
          )
        : const SizedBox.shrink(key: ValueKey('empty')),
  );
}
