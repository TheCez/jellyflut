import 'package:flutter/material.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/screens/home/components/search/search_no_results_placeholder.dart';
import 'package:provider/provider.dart';

class SearchResult extends StatefulWidget {
  SearchResult();

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late final SearchProvider searchProvider;
  late final ScrollController scrollController;
  late final TextEditingController searchController;
  late final List<Item> items;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    searchProvider = SearchProvider();
    searchController = TextEditingController();
    scrollController = ScrollController();
    items = [];
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, search, child) {
      if (search.searchResult.isNotEmpty) {
        return ListView.builder(
          itemCount: search.searchResult.length,
          controller: scrollController,
          scrollDirection: Axis.vertical,
          itemBuilder: (_, index) {
            final category =
                search.searchResult.values.toList().elementAt(index);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ListItems.fromFuture(
                  key: ValueKey(category),
                  itemsFuture: category,
                  horizontalListPosterHeight: itemPosterHeight,
                  showIfEmpty: false,
                  showTitle: true,
                  showSorting: false,
                  listType: ListType.POSTER),
            );
          },
        );
      } else if (search.searchResult.isEmpty) {
        return const SearchNoResultsPlaceholder();
      } else {
        return const SizedBox();
      }
    });
  }
}
