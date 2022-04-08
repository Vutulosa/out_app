import 'package:flutter/material.dart';
import 'package:out_app/shared/shared_components/functions.dart';
import 'package:out_app/shared/shared_components/table_icon.dart';
import 'package:out_app/user_side/home_body/components/card_components/price.dart';

class SearchCardSubHead extends StatelessWidget {
  const SearchCardSubHead(
      {Key? key,
      required this.tables,
      required this.opened,
      required this.price,
      required this.type,
      required this.rating,
      required this.distance})
      : super(key: key);
  final dynamic tables;
  final bool opened;
  final dynamic price;
  final String type;
  final dynamic rating;
  final String distance;

  @override
  Widget build(BuildContext context) {
    TextStyle openedStyle = getOpenedBulletStyle(opened);

    return Column(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      WidgetSpan(
                        child: getTableIcon(tables.round(), 20),
                      ),
                      TextSpan(
                        text: ' ' + tables.toString(),
                      ),
                      TextSpan(text: '  •  ', style: openedStyle),
                      getOpenedTextFormatted(opened)
                    ],
                  ),
                ),
                Text(getPriceFromInt(price.round())),
              ])),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.merge(const TextStyle(height: 1)),
                  children: [
                    TextSpan(text: type + "  "),
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Icon(
                        Icons.star,
                        size: 16,
                        color: Color(0xFFFFB800),
                      ),
                    ),
                    TextSpan(text: " " + rating.toString()),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Icon(
                        Icons.near_me,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(text: distance),
                  ],
                ),
              )
            ],
          ))
    ]);
  }
}
