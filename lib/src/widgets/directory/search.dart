import 'package:flutter/material.dart';

import '../../generated/dart_bindings.dart' as sdk;
import '../either.dart';
import 'object_card.dart';
import 'search_bar.dart';
import 'search_widget_color_scheme.dart';

/// Виджет, представляющий собой поисковую строку и лист выдачи объектов
/// или подсказок.
class DgisSearchWidget extends StatefulWidget {
  final sdk.SearchManager _searchManager;
  final void Function(sdk.DirectoryObject)? _onObjectSelected;
  final SearchResultBuilder? resultBuilder;
  final SearchWidgetColorScheme colorScheme;

  const DgisSearchWidget({
    required sdk.SearchManager searchManager,
    void Function(sdk.DirectoryObject)? onObjectSelected,
    this.resultBuilder,
    this.colorScheme = defaultSearchWidgetColorScheme,
    super.key,
  })  : _onObjectSelected = onObjectSelected,
        _searchManager = searchManager,
        assert(
          onObjectSelected == null || resultBuilder == null,
          'You can only provide either onObjectSelected or resultBuilder, not both.',
        );

  // Цветовая схема виджета по-умолчанию.
  static const defaultSearchWidgetColorScheme = SearchWidgetColorScheme(
    searchBarBackgroundColor: Colors.white,
    searchBarTextFieldColor: Colors.grey,
    objectCardTileColor: Colors.white,
    objectCardHighlightedTextStyle:
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    objectCardNormalTextStyle: TextStyle(color: Colors.black),
    objectListSeparatorColor: Colors.grey,
    objectListBackgroundColor: Colors.white,
  );

  @override
  State<DgisSearchWidget> createState() => _DgisSearchWidgetState();
}

class _DgisSearchWidgetState extends State<DgisSearchWidget> {
  final _scrollController = ScrollController();
  final _controller = TextEditingController();
  final ValueNotifier<List<EitherDirectoryObjOrSuggest>> _objects =
      ValueNotifier([]);
  sdk.Page? searchPage;

  void onPerformSearchSuggestSelected(sdk.PerformSearchHandler handler) {
    _performSearch(handler.searchQuery);
  }

  void onIncompleteTextSuggestSelected(String additionalQueryText) {
    _controller.text = additionalQueryText;
  }

  Future<void> _getSuggetions(String query) async {
    if (query.isNotEmpty) {
      final suggestions = await widget._searchManager
          .suggest(sdk.SuggestQueryBuilder.fromQueryText(query).build())
          .value;
      _objects.value = suggestions.suggests.map(SuggestUIObj.new).toList();
    } else {
      _objects.value = [];
    }
  }

  void _performSearchFromText(String query) {
    _performSearch(
      sdk.SearchQueryBuilder.fromQueryText(query).setPageSize(15).build(),
    );
  }

  Future<void> _performSearch(sdk.SearchQuery query) async {
    final result = await widget._searchManager.search(query).value;
    searchPage = result.firstPage;
    _objects.value = searchPage?.items.map(DirectoryUIObj.new).toList() ?? [];
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      _objects.value.last.fold(
        (left) => {
          searchPage?.fetchNextPage().then((p0) {
            searchPage = p0;
            _objects.value.addAll(
              p0?.items.map(DirectoryUIObj.new).toList() ?? [],
            );
          }),
        },
        (right) => null,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _handleSuggestionTap(EitherDirectoryObjOrSuggest suggestion) {
    suggestion.fold(
      (left) => {widget._onObjectSelected!(left)},
      (right) => {
        if (right.handler.isObjectHandler)
          {
            widget._onObjectSelected!(
              right.handler.asObjectHandler!.item,
            ),
            _controller.text = right.title.text,
          }
        else if (right.handler.isIncompleteTextHandler)
          {
            onIncompleteTextSuggestSelected(
              right.handler.asIncompleteTextHandler!.queryText,
            ),
          }
        else if (right.handler.isPerformSearchHandler)
          {
            onPerformSearchSuggestSelected(
              right.handler.asPerformSearchHandler!,
            ),
            _controller.text = right.title.text,
          }
        else
          {
            throw Exception(
              'Unknown SuggestHandler type: ${right.handler.runtimeType}',
            ),
          },
      },
    );
    _objects.value = [];
  }

  Widget _defaultSearchResultListBuilder(
    BuildContext context,
    List<EitherDirectoryObjOrSuggest> objects,
  ) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: objects.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 54),
        child: Divider(
          height: 1,
          thickness: 1,
          color: widget.colorScheme.objectListSeparatorColor,
        ),
      ),
      itemBuilder: (context, index) {
        final suggestion = objects[index];
        return SuggestionCard(
          objectCardHighlightedTextStyle:
              widget.colorScheme.objectCardHighlightedTextStyle,
          objectCardNormalTextStyle:
              widget.colorScheme.objectCardNormalTextStyle,
          objectCardTileColor: widget.colorScheme.objectCardTileColor,
          suggestion: suggestion,
          onTap: () => _handleSuggestionTap(suggestion),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DgisSearchBar(
          onSearchSubmitted: _performSearchFromText,
          onSearchChanged: _getSuggetions,
          controller: _controller,
          searchBarBackgroundColor: widget.colorScheme.searchBarBackgroundColor,
          searchBarTextFieldColor: widget.colorScheme.searchBarTextFieldColor,
          searchBarTextStyle: widget.colorScheme.searchBarTextStyle,
        ),
        Expanded(
          child: ColoredBox(
            color: widget.colorScheme.objectListBackgroundColor,
            child: ValueListenableBuilder(
              valueListenable: _objects,
              builder: (context, objects, _) {
                if (widget.resultBuilder != null) {
                  return widget.resultBuilder!(
                    context,
                    objects,
                  );
                }
                return _defaultSearchResultListBuilder(context, objects);
              },
            ),
          ),
        ),
      ],
    );
  }
}

typedef SearchResultBuilder = Widget Function(
  BuildContext context,
  List<EitherDirectoryObjOrSuggest> objects,
);
