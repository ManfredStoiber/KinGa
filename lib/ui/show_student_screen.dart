import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/students_cubit.dart';
import 'package:kinga/ui/attendance_screen.dart';
import 'package:kinga/ui/widgets/expandable_fab.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kinga/constants/strings.dart';
import '../domain/entity/caregiver.dart';

class ShowStudentScreen extends StatefulWidget {
  // TODO: make constructor const again
  //ShowStudentScreen({Key? key, required this.studentId,}) : student = GetIt.I<StudentService>().getStudent(studentId), super(key: key);
  ShowStudentScreen({Key? key, required this.studentId,}) : super(key: key);

  final String studentId;


  @override
  State<ShowStudentScreen> createState() => _ShowStudentScreenState();
}

class _ShowStudentScreenState extends State<ShowStudentScreen> {

  pick() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: image!.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          lockAspectRatio: true,
          initAspectRatio: CropAspectRatioPreset.square,
          hideBottomControls: true,
          //statusBarColor: Theme.of(context).primaryColor,
          toolbarColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        IOSUiSettings(
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          rectWidth: 1,
          rectHeight: 1,
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentsCubit, StudentsState>(
  builder: (context, state) {
    if (state is StudentsLoaded) {
      Student student = state.getStudent(widget.studentId);
      return Scaffold(
        appBar: AppBar(
          title: Text("${student.firstname} ${student.lastname}"),
        ),
        body: Stack(
            children: [ ListView(
                children: [
                  Container(
                    height: 200,
                    margin: EdgeInsets.all(20),
                    child: Expanded(
                        child: Stack(
                          children: [
                            Hero(
                                tag: "hero${student.studentId}",
                                child: SvgPicture.asset('assets/images/hamster.svg',)
                            ),
                            Visibility(
                                visible: BlocProvider.of<StudentsCubit>(context).hasBirthday(widget.studentId),
                                child: const Icon(Icons.cake)
                            ),
                          ]
                        )
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    endIndent: 15,
                    indent: 15,
                    height: 50,
                  ),
                  Card(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent),
                      child: ExpansionTile(

                        title: Text(Strings.infoGeneral),
                        children: [
                          buildReadOnlyTextField(Strings.firstname, student.firstname),
                          buildReadOnlyTextField(Strings.middlename, student.middlename),
                          buildReadOnlyTextField(Strings.lastname, student.lastname),
                          buildReadOnlyTextField(Strings.birthday, "05.12.2019"), // TODO
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: ExpansionTile(
                      title: Text(Strings.infoPickup),
                      children: [
                        buildReadOnlyTextField('Bezeichnung', 'Mama'),
                        buildReadOnlyTextField('Vorname', 'Martina'),
                        buildReadOnlyTextField('Nachname', 'Weber'),
                        Row(
                          children: [
                            SizedBox(width: 200, child: buildReadOnlyTextField('Label', 'Handy Arbeit')),
                            SizedBox(width: 200, child: buildReadOnlyTextField('Nummer', '016293958')),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 200, child: buildReadOnlyTextField('Label', 'Handy Privat')),
                            SizedBox(width: 200, child: buildReadOnlyTextField('Nummer', '015193570')),
                          ],
                        ),
                        buildReadOnlyTextField('E-Mail', 'martinaweber@mustermail.de'),
                      ],
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: ExpansionTile(title: Text(Strings.infoHealth)),
                  ),
                  Card(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: ExpansionTile(
                      title: Text(Strings.permission),
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Set<String> permissions = {'Foto auf der Website', 'Barfuß laufen'};
                            return ListTile(
                              title: Text(permissions.elementAt(index))
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(height: 1,),
                          itemCount: 2,
                        )
                    ],),
                  ),
                ]
            ),
            ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ExpandableFab(
          distance: 150,
          icon: Icon(Icons.quick_contacts_dialer, color: Colors.white,),
          color: Theme
              .of(context)
              .errorColor,
          children: buildContact(student.caregivers)
          ,
        ),
      );
    } else {
      return Text('Not loaded yet'); // TODO
    }
  },
    );
  }

  Container buildReadOnlyTextField(String label, String text) {
    TextEditingController controller = TextEditingController();
    controller.text = text;
    if (text.isEmpty) return Container();

    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        enabled: false,
        readOnly: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label
        ),
        controller: controller,
      ),
    );
  }

  List<ActionButton> buildContact(List<Caregiver> caregivers) {
    List<ActionButton> contacts = List.empty(growable: true);
    for (var caregiver in caregivers) {
      caregiver.phoneNumbers.forEach((label, phoneNumber) {
        contacts.add(ActionButton(
            icon: Icon(Icons.phone, color: Colors.white),
            text: "${caregiver.firstname} ${caregiver.lastname} ($label)",
            onPressed: () async{
              Uri number = Uri.parse('tel:$phoneNumber');
              await launchUrl(number);
            },
        ));
      });
    }
    return contacts;
  }
}

