import 'dart:ui';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/components/episode_item.dart';
import 'package:jellyflut/components/list_items/components/list_items_sort_field_button.dart';
import 'package:jellyflut/components/list_items/skeleton/list_items_skeleton.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'bloc/collection_bloc.dart';
import 'components/music_item.dart';

part 'components/carousel_background.dart';
part 'components/list_items_sort.dart';
part 'components/list_title.dart';
part 'list_types/list_items_grid.dart';
part 'list_types/list_items_horizontal_list.dart';
part 'list_types/list_items_vertical_list.dart';

class ListItems extends StatefulWidget {
  final Future<Category>? itemsFuture;
  final Future<Category> Function(int startIndex, int numberOfItemsToLoad)
      loadMoreFunction;
  final Category? category;
  final CollectionBloc? collectionBloc;
  final ListType listType;
  final BoxFit boxFit;
  final bool showTitle;
  final bool showIfEmpty;
  final bool showSorting;
  final double horizontalListPosterHeight;
  final double verticalListPosterHeight;
  final double gridPosterHeight;
  final ScrollPhysics physics;
  final Widget Function(BuildContext)? placeholder;

  const ListItems.fromFuture(
      {super.key,
      required this.itemsFuture,
      this.loadMoreFunction = _defaultLoadMore,
      this.collectionBloc,
      this.placeholder,
      this.showTitle = false,
      this.boxFit = BoxFit.cover,
      this.showIfEmpty = true,
      this.showSorting = true,
      this.horizontalListPosterHeight = double.infinity,
      this.verticalListPosterHeight = double.infinity,
      this.gridPosterHeight = double.infinity,
      this.physics = const ClampingScrollPhysics(),
      this.listType = ListType.POSTER})
      : category = null;

  const ListItems.fromList(
      {super.key,
      required this.category,
      this.collectionBloc,
      this.placeholder,
      this.loadMoreFunction = _defaultLoadMore,
      this.showTitle = false,
      this.boxFit = BoxFit.cover,
      this.showIfEmpty = true,
      this.showSorting = true,
      this.horizontalListPosterHeight = double.infinity,
      this.verticalListPosterHeight = double.infinity,
      this.gridPosterHeight = double.infinity,
      this.physics = const ClampingScrollPhysics(),
      this.listType = ListType.POSTER})
      : itemsFuture = null;

  static Future<Category> _defaultLoadMore(int i, int l) {
    return Future.value(
        Category(items: <Item>[], startIndex: 0, totalRecordCount: 0));
  }

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController scrollController;
  late final CollectionBloc collectionBloc;
  late final List<ListType> listTypes;
  late Widget Function(BuildContext)? placeholder;
  late double horizontalListPosterHeight;
  late double verticalListPosterHeight;
  late double gridPosterHeight;
  late BoxFit boxFit;

  // late final CarrousselProvider carrousselProvider;

  void _scrollListener() {
    if (scrollController.position.extentAfter < 500) {
      collectionBloc.add(LoadMoreItems());
    }
  }

  @override
  void initState() {
    super.initState();
    // carrousselProvider = CarrousselProvider();
    listTypes = ListType.values;

    // BLoC init part
    collectionBloc = widget.collectionBloc ??
        CollectionBloc(
            listType: widget.listType,
            loadMoreFunction: widget.loadMoreFunction);
    collectionBloc.listType.add(widget.listType);

    // scroll listener to add items on scroll only if loadmore function as been defined
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    _setdataToBloc();
    horizontalListPosterHeight = widget.horizontalListPosterHeight;
    verticalListPosterHeight = widget.verticalListPosterHeight;
    gridPosterHeight = widget.gridPosterHeight;
    boxFit = widget.boxFit;
    placeholder = widget.placeholder;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    collectionBloc.close();
    super.dispose();
  }

  void _setdataToBloc() {
    // If it's closed we prevent this method from using closed objects
    if (collectionBloc.isClosed) return;

    // init Items
    if (widget.itemsFuture != null) {
      widget.itemsFuture!.then((Category category) {
        if (!collectionBloc.isClosed) {
          collectionBloc.add(AddItem(items: category.items));
        }
      });
    } else {
      if (!collectionBloc.isClosed) {
        collectionBloc.add(AddItem(items: widget.category?.items ?? <Item>[]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: collectionBloc,
      child: sortingThenbuildSelection(),
    );
  }

  Widget sortingThenbuildSelection() {
    if (widget.showSorting) {
      return ListItemsSort(
          listTypes: listTypes, child: Expanded(child: buildList()));
    }
    return buildList();
  }

  Widget buildList() {
    return BlocBuilder<CollectionBloc, CollectionState>(
        bloc: collectionBloc,
        builder: (context, collectionState) {
          if (collectionState is CollectionLoadedState) {
            if (collectionBloc.items.isNotEmpty) {
              return dataBuilder(collectionBloc.items);
            }
            return emptyCollection();
          } else if (collectionState is CollectionErrorState) {
            return Center(child: Text('error'.tr()));
          } else if (collectionState is CollectionLoadingState) {
            return ListItemsSkeleton(
                gridPosterHeight: gridPosterHeight,
                verticalListPosterHeight: verticalListPosterHeight,
                horizontalListPosterHeight: horizontalListPosterHeight,
                listType: collectionBloc.listType.stream.value);
          }
          return const SizedBox();
        });
  }

  Widget emptyCollection() {
    if (widget.showIfEmpty) {
      return Center(child: Center(child: Text('empty_collection'.tr())));
    }
    return const SizedBox();
  }

  Widget dataBuilder(List<Item> items) {
    return StreamBuilder<ListType>(
        stream: collectionBloc.listType.stream,
        initialData:
            collectionBloc.listType.stream.valueOrNull ?? widget.listType,
        builder:
            (BuildContext context, AsyncSnapshot<ListType> snapshotListType) {
          switch (snapshotListType.data) {
            case ListType.LIST:
              return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: ListTitle(
                    item: items.first,
                    showTitle: widget.showTitle,
                    child: ListItemsVerticalList(
                      items: items,
                      boxFit: boxFit,
                      placeholder: placeholder,
                      verticalListPosterHeight: verticalListPosterHeight,
                      scrollPhysics: widget.physics,
                      scrollController: scrollController,
                    ),
                  ));
            case ListType.POSTER:
              return ListTitle(
                item: items.first,
                showTitle: widget.showTitle,
                child: ListItemsHorizontalList(
                    items: items,
                    boxFit: boxFit,
                    placeholder: placeholder,
                    horizontalListPosterHeight: horizontalListPosterHeight,
                    scrollPhysics: widget.physics,
                    scrollController: scrollController),
              );
            case ListType.GRID:
              return ListTitle(
                  item: items.first,
                  showTitle: widget.showTitle,
                  child: ListItemsGrid(
                      items: items,
                      boxFit: boxFit,
                      placeholder: placeholder,
                      gridPosterHeight: gridPosterHeight,
                      scrollPhysics: widget.physics,
                      scrollController: scrollController));
            default:
              return ListTitle(
                item: items.first,
                showTitle: widget.showTitle,
                child: ListItemsGrid(
                    items: items,
                    placeholder: placeholder,
                    boxFit: boxFit,
                    gridPosterHeight: gridPosterHeight,
                    scrollPhysics: widget.physics,
                    scrollController: scrollController),
              );
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
