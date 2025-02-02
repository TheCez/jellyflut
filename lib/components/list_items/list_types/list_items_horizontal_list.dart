part of '../list_items_parent.dart';

class ListItemsHorizontalList extends StatelessWidget {
  final List<Item> items;
  final ScrollPhysics scrollPhysics;
  final ScrollController scrollController;
  final double horizontalListPosterHeight;
  final BoxFit boxFit;
  final Widget Function(BuildContext)? placeholder;

  const ListItemsHorizontalList(
      {super.key,
      this.boxFit = BoxFit.cover,
      this.placeholder,
      required this.items,
      required this.scrollPhysics,
      required this.horizontalListPosterHeight,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: horizontalListPosterHeight,
      child: ListView.builder(
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          physics: scrollPhysics,
          itemBuilder: (context, index) => ItemPoster(
                items.elementAt(index),
                boxFit: boxFit,
                placeholder: placeholder,
                width: double.infinity,
                height: double.infinity,
              )),
    );
  }
}
