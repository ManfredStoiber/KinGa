import 'package:flutter/material.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/student.dart';

class ShowStudentDataScreen extends StatelessWidget {

  final Student student;

  const ShowStudentDataScreen(this.student, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${Strings.studentsData}: ${student.firstname}${student.middlename.isNotEmpty ? " ${student.middlename}" : ""} ${student.lastname}"),
        actions: [
          IconButton(onPressed: () {
            // TODO
          }, icon: const Icon(Icons.edit))
        ],
      ),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Theme(
            data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent),
            child: ExpansionTile(

              title: const Text(Strings.infoGeneral),
              children: [
                buildReadOnlyTextField(Strings.firstname, student.firstname),
                buildReadOnlyTextField(Strings.middlename, student.middlename),
                buildReadOnlyTextField(Strings.lastname, student.lastname),
                buildReadOnlyTextField(Strings.birthday, "05.12.2019"), // TODO
              ],
            ),
          ),
        ),
        const Card(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ExpansionTile(title: Text(Strings.infoPickup)),
        ),
        const Card(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ExpansionTile(title: Text(Strings.infoHealth)),
        ),
        const Card(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ExpansionTile(title: Text(Strings.permission)),
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

}
