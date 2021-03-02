import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/card/cardItemWithChild.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/BackgroundImage.dart';

import 'collection.dart';

class Details extends StatefulWidget {
  final Item item;
  final String heroTag;
  const Details({@required this.item, @required this.heroTag});

  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

final playableItems = [
  'musicalbum',
  'music',
  'movie',
  'series',
  'season',
  'episode',
  'book'
];

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MusicPlayerFAB(
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: body(
                heroTag: widget.heroTag,
                size: size,
                item: widget.item,
                context: context)));
  }
}

Widget body(
    {@required Item item,
    @required String heroTag,
    @required Size size,
    @required BuildContext context}) {
  return Stack(alignment: Alignment.center, children: [
    Hero(tag: heroTag, child: BackgroundImage(item: item)),
    ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
          children: [
            buildElements(item: item, size: size, context: context),
            SizedBox(
              height: 20,
            ),
            Collection(item),
          ]),
    ),
  ]);
}

Widget buildElements(
    {@required Size size,
    @required Item item,
    @required BuildContext context}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.10),
        if (item?.imageBlurHashes?.logo != null) logo(item, size),
        SizedBox(height: size.height * 0.05),
        futureItemDetails(item: item, size: size),
      ]);
}

Widget logo(Item item, Size size) {
  return Container(
      width: size.width,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      constraints: BoxConstraints(maxWidth: 400),
      height: 100,
      child: AsyncImage(
        item.correctImageId(searchType: 'logo'),
        item.correctImageTags(searchType: 'logo'),
        item.imageBlurHashes,
        boxFit: BoxFit.contain,
        tag: 'Logo',
      ));
}

Widget futureItemDetails({@required Item item, @required Size size}) {
  return FutureBuilder<dynamic>(
    future: _getItemsCustom(itemId: item.id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return buildCard(snapshot.data[1], size, context);
      }
      return _placeHolderBody(item, size);
    },
  );
}

Widget buildCard(Item item, Size size, BuildContext context) {
  if (item.id != null) {
    return card(item, size, context);
  }
  return Container();
}

Widget card(Item item, Size size, BuildContext context) {
  return Stack(clipBehavior: Clip.hardEdge, children: <Widget>[
    Container(
        padding: EdgeInsets.only(top: 25), child: CardItemWithChild(item)),
    playableItems.contains(item.type.trim().toLowerCase())
        ? Positioned.fill(
            child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width * 0.5),
              child: PaletteButton(
                'Play',
                () {
                  item.playItem(context);
                },
                item: item,
                icon: Icons.play_circle_outline,
              ),
            ),
          ))
        : Container()
  ]);
}

Widget _placeHolderBody(Item item, Size size) {
  return Container(
      child: CardItemWithChild(
    item,
    isSkeleton: true,
  ));
}

Future _getItemsCustom({@required String itemId}) async {
  var futures = <Future>[];
  futures.add(Future.delayed(Duration(milliseconds: 400)));
  futures.add(getItem(itemId));
  return Future.wait(futures);
}
