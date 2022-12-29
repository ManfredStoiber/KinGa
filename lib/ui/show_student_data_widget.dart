import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/util/date_utils.dart';

class ShowStudentDataWidget extends StatefulWidget {

  final Student student;

  const ShowStudentDataWidget(this.student, {Key? key}) : super(key: key);

  @override
  State<ShowStudentDataWidget> createState() => _ShowStudentDataWidgetState();
}

class _ShowStudentDataWidgetState extends State<ShowStudentDataWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.only(bottom: kToolbarHeight),
      child: Column(children: [
        Card(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ExpansionTile(
            onExpansionChanged: (expanded) {
              if (expanded)  {
                GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsShowInfoGeneral);
              }
            },
            title: const Text(Strings.infoGeneral),
            children: [
              buildReadOnlyTextField(Strings.firstname, widget.student.firstname),
              buildReadOnlyTextField(Strings.middlename, widget.student.middlename),
              buildReadOnlyTextField(Strings.lastname, widget.student.lastname),
              if (widget.student.birthday != "") buildReadOnlyTextField(Strings.birthday, IsoDateUtils.getGermanDateFromIsoDate(widget.student.birthday)),
              buildReadOnlyTextField(Strings.address, widget.student.address)
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ExpansionTile(
            onExpansionChanged: (value) {
              GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsShowInfoPickup);
            },
            title: const Text(Strings.infoPickup),
            children: [
              if (widget.student.caregivers.isNotEmpty)
                ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(widget.student.caregivers.elementAt(index).label,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              )
                          ),
                          buildReadOnlyTextField(Strings.firstname, widget.student.caregivers.elementAt(index).firstname),
                          buildReadOnlyTextField(Strings.lastname, widget.student.caregivers.elementAt(index).lastname),
                          for (MapEntry phoneNumber in widget.student.caregivers.elementAt(index).phoneNumbers.entries)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: buildReadOnlyTextField(Strings.phoneLabel, phoneNumber.key)),
                                Expanded(child: buildReadOnlyTextField(Strings.phoneNumber, phoneNumber.value)),
                            ],
                          ),
                        buildReadOnlyTextField(Strings.email, widget.student.caregivers.elementAt(index).email),
                      ],
                    )  ;
                  },
                  separatorBuilder: (context, index) => const Divider(height: 1,),
                  itemCount: widget.student.caregivers.length
              )
          ],
        ),
      ),
/*        const Card(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ExpansionTile(title: Text(Strings.infoHealth)),
        ),*/
        if (widget.student.permissions.isNotEmpty)
          Card(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: ExpansionTile(
              onExpansionChanged: (value) {
                GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsShowInfoPermissions);
              },
              title: const Text(Strings.permission),
              children: [
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(widget.student.permissions.elementAt(index)),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(height: 1,),
                  itemCount: widget.student.permissions.length
                )
              ],
            ),
          ),
      ],),
    );
  }

  Container buildReadOnlyTextField(String label, String text) {
    TextEditingController controller = TextEditingController();
    controller.text = text;
    if (text.isEmpty) return Container();

    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        enabled: false,
        readOnly: true,
        decoration:
        InputDecoration(border: const OutlineInputBorder(), labelText: label),
        controller: controller,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
