import 'package:flutter/material.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/ui/edit_student_screen.dart';
import 'package:kinga/util/date_utils.dart';

class ShowStudentDataScreen extends StatelessWidget {

  final Student student;

  const ShowStudentDataScreen(this.student, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Strings.studentsData}: ${student.firstname}${student.middlename.isNotEmpty ? " ${student.middlename}" : ""} ${student.lastname}"),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditStudentScreen(student: student,))), icon: const Icon(Icons.edit))
        ],
      ),
      body: ListView(
        children: [
          Column(children: [
            Card(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ExpansionTile(

                title: const Text(Strings.infoGeneral),
                children: [
                  buildReadOnlyTextField(Strings.firstname, student.firstname),
                  buildReadOnlyTextField(Strings.middlename, student.middlename),
                  buildReadOnlyTextField(Strings.lastname, student.lastname),
                  buildReadOnlyTextField(Strings.birthday, IsoDateUtils.getGermanDateFromIsoDate(student.birthday)),
                  buildReadOnlyTextField(Strings.address, student.address)
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ExpansionTile(
                title: const Text(Strings.infoPickup),
                children: [
                  student.caregivers.isNotEmpty ?
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(student.caregivers.elementAt(index).label,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ),
                                buildReadOnlyTextField(Strings.firstname, student.caregivers.elementAt(index).firstname),
                                buildReadOnlyTextField(Strings.lastname, student.caregivers.elementAt(index).lastname),
                                for (MapEntry phoneNumber in student.caregivers.elementAt(index).phoneNumbers.entries)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: 200, child: buildReadOnlyTextField(Strings.phoneLabel, phoneNumber.key)),
                                      SizedBox(width: 200, child: buildReadOnlyTextField(Strings.phoneNumber, phoneNumber.value)),
                                    ],
                                  ),
                                buildReadOnlyTextField(Strings.email, student.caregivers.elementAt(index).email),
                              ],
                            )  ;
                          },
                          separatorBuilder: (context, index) => const Divider(height: 1,),
                          itemCount: student.caregivers.length
                      ) : Container()
                ],
              ),
            ),
/*        const Card(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ExpansionTile(title: Text(Strings.infoHealth)),
            ),*/
            student.permissions.isNotEmpty ? Card(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ExpansionTile(
                  title: const Text(Strings.permission),
                  children: [
                      ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(student.permissions.elementAt(index)),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(height: 1,),
                          itemCount: student.permissions.length
                      )
                  ],
              ),
            ) : Container(),
          ],),
        ],
      ),
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

}
