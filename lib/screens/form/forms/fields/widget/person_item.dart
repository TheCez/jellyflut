import 'package:flutter/material.dart';

import 'package:jellyflut/components/people_poster.dart';
import 'package:jellyflut/models/jellyfin/person.dart';

class PersonItem extends StatelessWidget {
  final Person? person;
  final double height;
  final VoidCallback onPressed;

  const PersonItem(
      {super.key,
      required this.person,
      required this.height,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (person == null) return SizedBox();
    final headlineColor = Theme.of(context).textTheme.headline6!.color;
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(child: PeoplePoster(person: person!, clickable: false)),
              SizedBox(width: 12),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(person!.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1),
                    if (person?.role != null)
                      Text(
                        person!.role!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 16)
                            .copyWith(color: headlineColor!.withAlpha(180)),
                      ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: onPressed,
                  hoverColor: Colors.red.withOpacity(0.1),
                  icon: Icon(Icons.delete_outline, color: Colors.red))
            ]),
      ),
    );
  }
}
