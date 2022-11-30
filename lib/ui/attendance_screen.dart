import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get_it/get_it.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/features/permissions/ui/list_permissions_screen.dart';
import 'package:kinga/shared/loading_indicator.dart';
import 'package:kinga/ui/new_student_screen.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/ui/show_student_screen.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/ui/widgets/drop.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';

import 'bloc/students_cubit.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  String selected = Strings.allGroups;
  bool activeSearch = false;
  String search = "";

  @override
  void initState() {
    super.initState();
  }

  void debugConvertFirebaseFromKingaLegacy() {
    FirebaseFirestore.instance.collection('Institution').doc('debug').delete().onError((error, stackTrace) => null);
    FirebaseFirestore.instance.collection('Institution').doc('f1x2NtOa90aJSlbOIX0fD4fOrns2').get().then((value) {
      FirebaseFirestore.instance.collection('Institution').doc('debug').set(value.data()!);
      FirebaseFirestore.instance.collection('Institution').doc('f1x2NtOa90aJSlbOIX0fD4fOrns2').collection('Student').get().then((value2) {
        for (var v in value2.docs) {
          var data = v.data();
          data['birthday'] = DateTime.fromMillisecondsSinceEpoch(data['birthday']).toIso8601String().substring(0, 10);
          data['attendances'] = [];
          data['incidents'] = [];
          data['kudos'] = [];
          var caregiversNew = [];
          for (var caregiver in data['caregivers']) {
            Map<String, String> phonenumbersNew = <String, String>{};
            for (var phonenumber in caregiver['phoneNumbers']) {
              phonenumbersNew[phonenumber['label']] = phonenumber['number'];
            }
            var tmp = Caregiver(caregiver['firstname'], caregiver['lastname'], caregiver['label'] ?? "", phonenumbersNew, caregiver['email']).toMap();
            caregiversNew.add(tmp);
          }
          data['caregivers'] = caregiversNew;
          FirebaseFirestore.instance.collection('Institution').doc('debug').collection('Student').add(data);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          //title: Text(widget.title),
            title: BlocBuilder<StudentsCubit, StudentsState>(
              builder: (context, state) {
                if (state is StudentsInitial || state is StudentsLoading) {
                  return const Text(Strings.loading);
                } else if (state is StudentsLoaded) {
                  return Row(
                      children: [
                        if (activeSearch) Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  search = value;
                                });
                              },
                              autofocus: true,
                              cursorColor: Colors.black38,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.black38,
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black38,
                                      )
                                  ),
                                  hintText: Strings.search,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        activeSearch = false;
                                      });
                                    },
                                    color: Colors.black38,
                                  )
                              ),
                            )
                        )
                        else Expanded(
                          child: DropdownButton<String>(
                            underline: Container(height: 1, color: Colors.black38,),
                            isExpanded: true,
                            value: selected,
                            items: [const DropdownMenuItem(value: Strings.allGroups, child: Text(Strings.allGroups))] + state.groups.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selected = newValue!;
                              });
                            },
                          ),
                        ),

                        if (!activeSearch) IconButton(
                            onPressed: () {
                              setState(() {
                                activeSearch = true;
                              });
                            },
                            icon: const Icon(Icons.search)
                        ),
                      ]
                  );
                } else {
                  return const Text("Exception");
                }
  },
)

        ),
        body: BlocBuilder<StudentsCubit, StudentsState>(
          builder: (context, state) {
            if (state is StudentsInitial || state is StudentsLoading) {
              return const LoadingIndicator();
            } else if (state is StudentsLoaded) {
              return GridView(
                padding: const EdgeInsets.all(10),
                // TODO: maybe move sorting to state or repository for better performance; include lastname for sorting
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                children: state.students
                    .where((student) =>
                (selected == Strings.allGroups ||
                    student.group == selected) && (!activeSearch ||
                    "${student.firstname} ${student.lastname}"
                        .toLowerCase()
                        .contains(search.toLowerCase())))
                    .map((e) =>
                    AttendanceItem(studentId: e.studentId))
                    .toList()
                  ..sort((a, b) => state.getStudent(a.studentId).compareTo(state.getStudent(b.studentId))),
              );
            } else {
              return const Text("Exception"); // TODO
            }
          }
        ),

        drawer: Drawer(
          backgroundColor: Theme.of(context).backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: const Center(child: Text(Strings.kinga))
              ),
              ListTile(
                title: const Text(Strings.newChild),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          const NewStudentScreen()));
                },
                leading: const Icon(Icons.add_circle_outline),
              ),
              ListTile(
                title: const Text(Strings.permission),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ListPermissionsScreen(),));
                },
                leading: const Icon(Icons.checklist),
              ),
              const Divider(),
              ListTile(
                title: const Text(Strings.support),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.question_answer),
              ),
              ListTile(
                title: const Text(Strings.feedback),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.chat_outlined),
              ),
              ListTile(
                title: const Text(Strings.impressum),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.domain),
              ),
              const Divider(),
              ListTile(
                title: const Text(Strings.settings),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.settings),
              ),
              ListTile(
                title: const Text(Strings.logout),
                onTap: () {
                  Navigator.pop(context);
                  GetIt.I<InstitutionRepository>().leaveInstitution();
                  FirebaseAuth.instance.signOut();
                },
                leading: const Icon(Icons.power_settings_new),
              ),
            ],
          ),
        )
    );
  }
}

class AttendanceItem extends StatefulWidget {
  const AttendanceItem({Key? key, required this.studentId}) : super(key: key);

  final String studentId;

  @override
  State<AttendanceItem> createState() => _AttendanceItemState();
}

class _AttendanceItemState extends State<AttendanceItem> {
  bool active = false;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentsCubit, StudentsState>(
      builder: (context, state) {
        if (state is StudentsLoaded) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              ShowStudentScreen(studentId: widget.studentId,)));
                    },
                    onLongPress: () {
                      BlocProvider.of<StudentsCubit>(context).toggleAttendance(
                          widget.studentId);
                    },
                    style: TextButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(64.0),
                        ),
                        backgroundColor: (){
                        StudentsCubit cubit = BlocProvider.of<StudentsCubit>(context);
                        if (cubit.isAbsent(widget.studentId)) {
                          return ColorSchemes.absentColor;
                        } else {
                          if (cubit.isAttendant(widget.studentId)) {
                            return ColorSchemes.attendantColor;
                          } else {
                            return ColorSchemes.notAttendantColor;
                          }
                        }
                      }()
                    ),
                    child: Column(
                        children: [
                          Expanded(
                            child: Hero(
                            tag: "hero${widget.studentId}",
                            child: () {
                              if (state.getStudent(widget.studentId).profileImage.isEmpty) {
                                return SvgPicture.asset(
                                  'assets/images/hamster.svg',);
                              } else {
                                return Container(margin: const EdgeInsets.only(top: 5), clipBehavior: Clip.antiAlias, decoration: ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(44))), child: Image.memory(fit: BoxFit.fitHeight, state.getStudent(widget.studentId).profileImage));
                              }
                              } ()
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text(state.getStudent(widget.studentId).firstname),
                          )
                        ]
                    )
                )
              ),
              Visibility(
                visible: BlocProvider.of<StudentsCubit>(context).hasBirthday(widget.studentId),
                child: Drop(image: Image.asset('assets/images/cupcake.png'), width: 35.0, height: 35.0, reversed: false,)
        ),
            ]
          );
        } else {
          throw Exception('Invalid State');
        }
      },
    );
  }
}