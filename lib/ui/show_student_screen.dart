import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/features/absences/ui/absence_screen.dart';
import 'package:kinga/ui/attendance_screen.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';
import 'package:kinga/ui/widgets/expandable_fab.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kinga/constants/strings.dart';

class ShowStudentScreen extends StatefulWidget {
  const ShowStudentScreen({Key? key, required this.studentId,}) : super(key: key);

  final String studentId;

  @override
  State<ShowStudentScreen> createState() => _ShowStudentScreenState();
}

class _ShowStudentScreenState extends State<ShowStudentScreen> {

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
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: const Text("Press"),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const AttendanceScreen()));
                          },
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () => debugPickImage(context, true, student.studentId), // TOOD: remove
                              child: Hero(
                                  tag: "hero${student.studentId}",
                                  child: () {
                                    if (state.getStudent(widget.studentId).profileImage.isEmpty) {
                                      return SvgPicture.asset(
                                        'assets/images/hamster.svg',);
                                    } else {
                                      return Image.memory(state.getStudent(widget.studentId).profileImage);
                                    }
                                  } ()
                              ),
                            ),
                            Visibility(
                                visible: BlocProvider.of<StudentsCubit>(context).hasBirthday(widget.studentId),
                                child: const Icon(Icons.cake)
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: const Text("Press"),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const AttendanceScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size.fromRadius(30)),
                          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                          shape: MaterialStateProperty.all(CircleBorder(
                          )),
                          side: MaterialStateProperty.all(BorderSide(color: ColorSchemes.kingacolor, width: 2))
                          //shape: MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(5000) )),
                        ),

                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AbsenceScreen(widget.studentId)));
                        },
                        child: const Icon(Icons.event_busy, size: 30,),
                      ),
                      Container(
                        width: 50,
                      ),
                      FloatingActionButton(
                        heroTag: "tmp2",
                        onPressed: () {

                        },),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    endIndent: 15,
                    indent: 15,
                    height: 50,
                  ),
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
                ]
            ),
            ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ExpandableFab(
          distance: 150,
          icon: const Icon(Icons.quick_contacts_dialer, color: Colors.white,),
          color: Theme
              .of(context)
              .errorColor,
          children: buildContact(student.caregivers)
          ,
        ),
      );
    } else {
      return const Text('Not loaded yet'); // TODO
    }
  },
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

  Future<bool> debugPickImage(BuildContext context, bool camera, String studentId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          cropStyle: CropStyle.circle,
          uiSettings: [
            AndroidUiSettings(
              lockAspectRatio: true,
              initAspectRatio: CropAspectRatioPreset.square,
              hideBottomControls: true,
              //statusBarColor: Theme.of(context).primaryColor,
              toolbarColor: Theme
                  .of(context)
                  .primaryColor,
              backgroundColor: Theme
                  .of(context)
                  .backgroundColor,
            ),
            IOSUiSettings(
              aspectRatioLockEnabled: true,
              aspectRatioPickerButtonHidden: true,
              rectWidth: 1,
              rectHeight: 1,
            )
          ]);
      if (croppedFile != null) {
        croppedFile.readAsBytes().then((value) {
          setState(() {
            BlocProvider.of<StudentsCubit>(context).setProfileImage(studentId, value);
          });
        });
        return Future(() => true);
      }
    }
    return Future(() => false);
  }


  List<ActionButton> buildContact(List<Caregiver> caregivers) {
    List<ActionButton> contacts = List.empty(growable: true);
    for (var caregiver in caregivers) {
      caregiver.phoneNumbers.forEach((label, phoneNumber) {
        contacts.add(ActionButton(
            icon: const Icon(Icons.phone, color: Colors.white),
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
