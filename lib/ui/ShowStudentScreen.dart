import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinga/data/FirebaseStudentRepository.dart';
import 'package:kinga/domain/StudentRepository.dart';
import 'package:kinga/domain/StudentService.dart';
import 'package:kinga/ui/AttendanceScreen.dart';
import 'package:kinga/ui/widgets/ExpandableFab.dart';

import 'package:kinga/constants/strings.dart';
import '../domain/entity/Student.dart';

class ShowStudentScreen extends StatefulWidget {
  // TODO: make constructor const again
  ShowStudentScreen({Key? key, required this.studentId,}) : student = GetIt.I<StudentService>().getStudent(studentId), super(key: key);

  final String studentId;
  final Student student;


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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.firstname + " " + widget.student.lastname),
      ),
      body: Stack(
        children: [ ListView(
            children: [
              Container(
                height: 200,
                margin: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        child: const Text("Press"),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScreen()));
                          pick();
                        },
                      ),
                    ),
                    Expanded(
                      child: SvgPicture.asset('assets/images/hamster.svg',)
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        child: const Text("Press"),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScreen()));
                          pick();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {

                  },),
                  Container(
                    width: 50,
                  ),
                  FloatingActionButton(onPressed: () {

                  },),
                ],
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
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(

                    title: Text(Strings.infoGeneral),
                    children: [
                      buildReadOnlyTextField("Vorname", "Adam"),
                      buildReadOnlyTextField("Zweitname", " "),
                      buildReadOnlyTextField("Nachname", "Hoffmann"),
                      buildReadOnlyTextField("Geburtsdatum", "05.12.2019"),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ExpansionTile(title: Text(Strings.infoPickup)),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ExpansionTile(title: Text(Strings.infoHealth)),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ExpansionTile(title: Text(Strings.permission)),
              ),
            ]
        ),
          Container(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Center(
                ),
              ),
              color: Color.fromRGBO(5, 5, 5, 0.5),
              height: MediaQuery.of(context).size.height
          )
      ]),
      floatingActionButton: ExpandableFab(
        distance: 150,
        icon: Icon(Icons.phone, color: Colors.white,),
        color: Theme.of(context).errorColor,
        children: [
          ActionButton(icon: Icon(Icons.email, color: Colors.white,)),
          ActionButton(icon: Icon(Icons.phone, color: Colors.white,)),
          ActionButton(icon: Icon(Icons.message, color: Colors.white,)),
        ],
      ),
    );
  }

  Container buildReadOnlyTextField(String label, String text) {
    TextEditingController _controller = TextEditingController();
    _controller.text = text;
    return Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: label
                    ),
                    controller: _controller,
                  ),
                );
  }
}

