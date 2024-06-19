import 'package:flutter/material.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/util/date_utils.dart';

class IncidenceItem extends StatefulWidget {
  const IncidenceItem(this.studentId, this.incidence, {Key? key}) : super(key: key);

  final String studentId;
  final Incidence incidence;

  @override
  State<IncidenceItem> createState() => _IncidenceItemState();
}

class _IncidenceItemState extends State<IncidenceItem> {
  final int maxChars = 100;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    bool expandable = widget.incidence.description.length >= maxChars;

    Color categoryColor = Colors.transparent;
    Color? categoryColorLight = Colors.transparent;
    switch(widget.incidence.category) {
      case Strings.achievement:
        categoryColor = Theme.of(context).primaryColor;
        categoryColorLight = ColorSchemes.kingacolor[100];
        break;
      case Strings.accident:
        categoryColor = ColorSchemes.errorColor;
        categoryColorLight = ColorSchemes.errorColorLight;
        break;
      case Strings.other:
        categoryColor = ColorSchemes.categoryColor;
        categoryColorLight = ColorSchemes.categoryColorLight;
        break;
    }

    return Card(
      child: Theme(
          data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent),
          child: InkWell(
            onTap: expandable?
                () => {
                  setState(() { expanded = !expanded; })
                }:
                null,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              width: double.infinity,
              child: Column(
                children: [
                  !expanded & expandable?
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(child: Text('${widget.incidence.description.substring(0, maxChars)}...')),
                    ],
                  ):
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(child: Text(widget.incidence.description)),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: categoryColorLight,
                          ),
                          child: Text(widget.incidence.category)
                        ),
                        const Spacer(),
                        Text(IsoDateUtils.getGermanDateFromDateTime(DateTime.parse(widget.incidence.dateTime)))
                      ]
                    ),
                  )
                ],
              ),
            ),
          )
       )
    );
  }
}



