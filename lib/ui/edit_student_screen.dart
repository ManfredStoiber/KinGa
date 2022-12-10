import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/features/create_student/ui/create_basic_info.dart';
import 'package:kinga/features/create_student/ui/create_caregivers.dart';
import 'package:kinga/features/create_student/ui/create_permissions.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';
import 'package:kinga/ui/show_student_data_screen.dart';
import 'package:kinga/ui/show_student_screen.dart';


class EditStudentScreen extends StatefulWidget {
  EditStudentScreen({this.student, Key? key}) : super(key: key);

  Student? student;

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen>
    with SingleTickerProviderStateMixin {
  List<GlobalKey<FormState>> tabKeys = [];

  final Set<String> optionalFields = {'middlename', 'email'};
  final int _maxTabIndex = 2;

  int _tabIndex = 0;
  late TabController _tabController;

  Map<String, dynamic> student = {};

  Uint8List _profileImage = Uint8List(0);

  List<Caregiver> caregivers = [];
  List<Map<String, dynamic>> caregiverMaps = [{'phoneNumbers': [['', '']]}];

  Set<String> permissions = {};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i <= _maxTabIndex; i++) {
      tabKeys.add(GlobalKey<FormState>());
    }

    _tabController = TabController(length: _maxTabIndex + 1, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });

    if (widget.student != null) {
      student = _studentToMap(widget.student!);
      _profileImage = student['profileImage'];
      permissions = student['permissions'];
      caregiverMaps = [];

      for (var caregiver in student['caregivers']) {
        Map<String, dynamic> caregiverMapped = Map<String, dynamic>.from(caregiver);
        caregiverMapped['phoneNumbers'] = [];
        for (MapEntry phoneNumber in caregiver['phoneNumbers'].entries) {
          caregiverMapped['phoneNumbers'].add([phoneNumber.key, phoneNumber.value]);
        }
        caregiverMaps.add(caregiverMapped);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: BottomAppBar(child: Container(height: 50,),),
      appBar: AppBar(
        title: widget.student == null ? const Text(Strings.createNewStudent) : const Text(Strings.editStudent),
        actions: [
          widget.student != null ? IconButton(onPressed: () {
            showDialog(context: context, builder: (context) => AlertDialog(
              title: const Text(Strings.deleteChild),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop(false);
                }, child: const Text(Strings.cancel)),
                TextButton(onPressed: () {
                  Navigator.of(context).pop(true);
                }, child: const Text(Strings.confirm)),
              ]
            )).then((confirmed) {
              Student? s = widget.student;
              if (confirmed && s != null) {
                BlocProvider.of<StudentsCubit>(context).deleteStudent(s.studentId);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            });
          }, icon: const Icon(Icons.delete_forever)) : Container()
        ],
        bottom: TabBar(controller: _tabController, isScrollable: true, tabs: const [
          Tab(text: Strings.infoGeneral),
          Tab(text: Strings.infoPickup),
          //Tab(text: Strings.infoHealth),
          Tab(text: Strings.permission),
        ],
          onTap: (index) async {
            if (index >= _tabController.previousIndex && !(tabKeys[_tabController.previousIndex].currentState?.validate() ?? true)) {
              _tabController.animateTo(_tabController.previousIndex, duration: const Duration(seconds: 0));
              await Future.delayed(const Duration(milliseconds: 100));
              tabKeys[_tabController.index].currentState?.validate();
            } else if (index == _maxTabIndex) {
              for (var i = 0; i < _maxTabIndex; i++) {
                if (!(tabKeys[i].currentState?.validate() ?? false)) {
                  _tabController.animateTo(i, duration: const Duration(seconds: 0));
                  await Future.delayed(const Duration(milliseconds: 100));
                  tabKeys[i].currentState?.validate();
                }
              }
            }
          },),
      ),
      body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            CreateBasicInfo(student, _profileImage, optionalFields, tabKeys[0], (newProfileImage) => setState(() => _profileImage = newProfileImage,)),
            CreateCaregivers(caregiverMaps, optionalFields, tabKeys[1]),
            //const Text('Page 3'),
            CreatePermissions(permissions),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Wrap(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Visibility(
                visible: _tabIndex != 0,
                child: FloatingActionButton(
                    heroTag: 'fab2',
                    onPressed: () {
                      _tabController.animateTo(_tabIndex - 1);
                    },
                    child: const Icon(Icons
                        .arrow_back)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: FloatingActionButton(
                  heroTag: 'fab1',
                  onPressed: () {
                    if (_tabIndex == _maxTabIndex) {
                      for (var caregiver in caregiverMaps) {
                        Map<String, dynamic> caregiverMapped = Map<String, dynamic>.from(caregiver);
                        caregiverMapped['phoneNumbers'] = {};
                        for (List<dynamic> phoneNumber in caregiver['phoneNumbers']) {
                          caregiverMapped['phoneNumbers'][phoneNumber[0]] = phoneNumber[1];
                        }
                        caregivers.add(Caregiver.fromMap(caregiverMapped));
                      }
                      student['caregivers'] = caregivers;
                      student['permissions'] = permissions;

                      if (widget.student == null) {
                        BlocProvider.of<StudentsCubit>(context).createStudent(student, _profileImage);
                      } else {
                        Student? s = widget.student;
                        if (s != null) {
                          s.firstname = student['firstname'];
                          s.middlename = student['middlename'];
                          s.lastname = student['lastname'];
                          s.birthday = student['birthday'];
                          s.address = student['address'];
                          s.group = student['group'];
                          s.caregivers = caregivers;
                          s.permissions = permissions;
                          BlocProvider.of<StudentsCubit>(context).updateStudent(s, _profileImage).then((_) {
                             Navigator.pop(context);
                             Navigator.pop(context);
                             Navigator.push(context, MaterialPageRoute(builder: (context) => ShowStudentScreen(studentId: s.studentId)));
                             Navigator.push(context, MaterialPageRoute(builder: (context) => ShowStudentDataScreen(s)));
                          });
                        }
                      }
                      Navigator.pop(context);
                    } else {
                      if (tabKeys[_tabIndex].currentState?.validate() ?? false) {
                        _tabController.animateTo(_tabIndex + 1);
                      }
                    }
                  },
                  child: (() {
                    if (_tabIndex == _maxTabIndex) {
                      return const Icon(Icons.check);
                    } else {
                      return const Icon(Icons.arrow_forward);
                    }
                  }())
              ),
            ),
          ],
        ),
      ]),
    );
  }


  Map<String, dynamic> _studentToMap(Student student) {
    {
      // convert student to map
      Map<String, dynamic> map = {
        'studentId': student.studentId,
        'firstname': student.firstname,
        'middlename': student.middlename,
        'lastname': student.lastname,
        'birthday': student.birthday,
        'address': student.address,
        'group': student.group,
      };

      List<Map<String, dynamic>> caregivers = [];
      for (final Caregiver caregiver in student.caregivers) {
        caregivers.add({
          'firstname': caregiver.firstname,
          'lastname': caregiver.lastname,
          'label': caregiver.label,
          'phoneNumbers': caregiver.phoneNumbers,
          'email': caregiver.email
        });
      }
      map['caregivers'] = caregivers;
      map['profileImage'] = student.profileImage;

      // permissions
      map['permissions'] = student.permissions.toSet();

      return map;
    }
  }
}