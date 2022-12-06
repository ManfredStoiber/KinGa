import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/features/create_student/ui/create_basic_info.dart';
import 'package:kinga/features/create_student/ui/create_caregivers.dart';
import 'package:kinga/features/create_student/ui/create_permissions.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';

import 'attendance_screen.dart';

class NewStudentScreen extends StatefulWidget {
  const NewStudentScreen({Key? key}) : super(key: key);

  @override
  State<NewStudentScreen> createState() => _NewStudentScreenState();
}

class _NewStudentScreenState extends State<NewStudentScreen>
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: BottomAppBar(child: Container(height: 50,),),
      appBar: AppBar(
        title: const Text(Strings.createNewStudent),
        bottom: TabBar(controller: _tabController, isScrollable: true, tabs: const [
          Tab(text: Strings.infoGeneral),
          Tab(text: Strings.infoPickup),
          //Tab(text: Strings.infoHealth),
          Tab(text: Strings.permission),
        ],
        onTap: (index) {
          if (index >= _tabController.previousIndex && !(tabKeys[_tabController.previousIndex].currentState?.validate() ?? true)) {
            _tabController.index = _tabController.previousIndex;
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
                          for (List<String> phoneNumber in caregiver['phoneNumbers']) {
                            caregiverMapped['phoneNumbers'][phoneNumber[0]] = phoneNumber[1];
                          }
                          caregivers.add(Caregiver.fromMap(caregiverMapped));
                        }
                        student['caregivers'] = caregivers;
                        student['permissions'] = permissions;
                        BlocProvider.of<StudentsCubit>(context).createStudent(student, _profileImage);
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
}