part of '../fields.dart';

class TagsField extends StatefulWidget {
  final Item item;
  final FormGroup form;
  final double ITEM_HEIGHT = 35;

  const TagsField({super.key, required this.form, required this.item});

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  late final Item item;
  late final FormGroup form;
  late final double ITEM_HEIGHT;

  @override
  void initState() {
    item = widget.item;
    form = widget.form;
    ITEM_HEIGHT = widget.ITEM_HEIGHT;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Tags', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 24),
        SizedBox(
            width: double.maxFinite,
            child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 10,
                children: generateAllTags(context))),
      ],
    );
  }

  List<Widget> generateAllTags(BuildContext context) {
    if (item.tags.isEmpty) return [];
    return item.tags.map((dynamic tag) => tagItem(tag, context)).toList();
  }

  Widget tagItem(String? tag, BuildContext context) {
    if (tag == null) return SizedBox();
    return Container(
        height: ITEM_HEIGHT,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.all(Radius.circular(ITEM_HEIGHT))),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: Text(
                  tag.capitalize(),
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary),
                )),
                IconButton(
                    onPressed: () => setState(() {
                          item.tags.removeAt(item.tags.indexOf(tag));
                        }),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.remove_circle_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ))
              ],
            )));
  }
}
