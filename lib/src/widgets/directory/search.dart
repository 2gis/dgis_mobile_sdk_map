import 'package:flutter/material.dart';

import '../../generated/dart_bindings.dart' as sdk;
import '../either.dart';
import 'object_card.dart';
import 'search_bar.dart';

class DgisSearchWidget extends StatefulWidget {
  final sdk.SearchManager _searchManager;
  final void Function(sdk.DirectoryObject) _onObjectSelected;

  const DgisSearchWidget({
    required void Function(sdk.DirectoryObject) onObjectSelected,
    required sdk.SearchManager searchManager,
    super.key,
  })  : _onObjectSelected = onObjectSelected,
        _searchManager = searchManager;

  @override
  DgisSearchWidgetState createState() => DgisSearchWidgetState();
}

class DgisSearchWidgetState extends State<DgisSearchWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  List<EitherDirectoryObjOrSuggest> _objects = [];
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
      setState(() {
        setState(() {
          _objects = suggestions.suggests.map(SuggestUIObj.new).toList();
        });
      });
    } else {
      setState(() {
        _objects = [];
      });
    }
  }

  void _performSearchFromText(String query) {
    _performSearch(
      sdk.SearchQueryBuilder.fromQueryText(query).setPageSize(15).build(),
    );
  }

  Future<void> _performSearch(sdk.SearchQuery query) async {
    final result = await widget._searchManager.search(query).value;
    setState(() {
      searchPage = result.firstPage;
      _objects = searchPage?.items.map(DirectoryUIObj.new).toList() ?? [];
    });
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      _objects.last.fold(
        (left) => {
          searchPage?.fetchNextPage().then(
                (p0) => setState(() {
                  searchPage = p0;
                  _objects.addAll(
                    p0?.items.map(DirectoryUIObj.new).toList() ?? [],
                  );
                }),
              ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DgisSearchBar(
          onSearchSubmitted: _performSearchFromText,
          onSearchChanged: _getSuggetions,
          controller: _controller,
        ),
        Expanded(
          child: ColoredBox(
            color: Colors.white,
            child: ListView.separated(
              controller: _scrollController,
              itemCount: _objects.length,
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(left: 54),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              itemBuilder: (context, index) {
                final suggestion = _objects[index];
                return SuggestionCard(
                  suggestion: suggestion,
                  onTap: () {
                    suggestion.fold(
                      (left) => {widget._onObjectSelected(left)},
                      (right) => {
                        if (right.handler.isObjectHandler)
                          {
                            widget._onObjectSelected(
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
                    setState(() {
                      _objects = [];
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
