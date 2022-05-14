import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreenHeading extends StatefulWidget {
  DashboardScreenHeading() : super();

  @override
  _DashboardScreenHeadingState createState() => _DashboardScreenHeadingState();
}

class _DashboardScreenHeadingState extends State<DashboardScreenHeading> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.headline5,
            children: [
              TextSpan(
                text: "${AppLocalizations.of(context).txt_get_your}",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: " ${AppLocalizations.of(context).txt_groceries}",
              ),
            ],
          ),
        ),
        Text(
          "${AppLocalizations.of(context).txt_delivered_quickly}",
          style: textTheme.headline6.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
