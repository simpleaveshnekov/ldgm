import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DateTimeSelector extends StatefulWidget {
  final String heading;
  final DateTime selectedDate;
  final Function onPressed;
  final key;

  DateTimeSelector({this.heading, this.selectedDate, this.onPressed, this.key}) : super();

  @override
  _DateTimeSelectorState createState() => _DateTimeSelectorState(heading: heading, selectedDate: selectedDate, onPressed: onPressed, key: key);
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  String heading;
  DateTime selectedDate;
  Function onPressed;
  Key key;
  _DateTimeSelectorState({this.heading, this.selectedDate, this.onPressed, this.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 80,
      color: Color(0xffF6F6F6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: textTheme.caption,
            ),
            Spacer(),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Text(
                    selectedDate != null ? DateFormat('EE, dd MMM').format(selectedDate).toString() : '${AppLocalizations.of(context).lbl_select_date}',
                    style: textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
