import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key, this.autofocus = false, required this.controller, this.onSubmitted});

  final bool autofocus;
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late final TextEditingController _searchController = widget.controller;

  final _focusNode = FocusNode();
  final _clearFocusNode = FocusNode();

  String get _filter => _searchController.value.text;

  @override
  void dispose() {
    _focusNode.dispose();
    _clearFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          iconSize: 16,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      child: TextField(
        autofocus: widget.autofocus,
        focusNode: _focusNode,
        controller: _searchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide.none,
          ),
          isDense: true,
          filled: true,
          hintText: AppLocalizations.of(context)!.searchHint,
          hintStyle: Theme.of(context).textTheme.labelMedium,
          contentPadding: EdgeInsets.zero,
          prefixIcon: const Icon(Icons.search),
          prefixIconConstraints: const BoxConstraints(maxHeight: 32, minWidth: 32),
          suffixIconConstraints: const BoxConstraints(minHeight: 36, minWidth: 36),
          suffixIcon: _filter.isEmpty
              ? const Icon(null)
              : IconButton(
                  focusNode: _clearFocusNode,
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                ),
        ),
        onTap: () {},
        onChanged: (_) {},
        onTapOutside: (_) => _focusNode.unfocus(),
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
