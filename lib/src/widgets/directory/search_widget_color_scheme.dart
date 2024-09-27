import 'package:flutter/material.dart';

class SearchWidgetColorScheme {
  final Color searchBarBackgroundColor;
  final Color searchBarTextFieldColor;
  final TextStyle? searchBarTextStyle;
  final Color objectCardTileColor;
  final TextStyle objectCardHighlightedTextStyle;
  final TextStyle objectCardNormalTextStyle;
  final Color objectListSeparatorColor;
  final Color objectListBackgroundColor;

  const SearchWidgetColorScheme({
    required this.searchBarBackgroundColor,
    required this.searchBarTextFieldColor,
    required this.objectCardTileColor,
    required this.objectCardHighlightedTextStyle,
    required this.objectCardNormalTextStyle,
    required this.objectListSeparatorColor,
    required this.objectListBackgroundColor,
    this.searchBarTextStyle,
  });
}
