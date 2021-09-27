import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/components/list_items.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/globals.dart' as globals;

class Tab extends StatefulWidget {
  final Item item;
  final double? itemPosterHeight;

  Tab({Key? key, required this.item, this.itemPosterHeight}) : super(key: key);

  @override
  _TabState createState() => _TabState();
}

class _TabState extends State<Tab> with AutomaticKeepAliveClientMixin {
  late Future<Category> itemsFuture;
  late double itemPosterHeight;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    itemsFuture = ItemService.getItems(parentId: widget.item.id);
    itemPosterHeight = widget.itemPosterHeight ?? globals.itemPosterHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListItems.fromFuture(
        itemsFuture: itemsFuture,
        itemPosterHeight: itemPosterHeight,
        physics: NeverScrollableScrollPhysics(),
        lisType: ListType.LIST);
  }
}
