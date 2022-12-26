import 'dart:typed_data';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/features/permissions/ui/list_permissions_screen.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/ui/new_student_screen.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/ui/show_student_screen.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/ui/widgets/drop.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'bloc/students_cubit.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey attendanceKey = GlobalKey();
  final GlobalKey createPermissionKey = GlobalKey();
  final GlobalKey createStudentKey = GlobalKey();
  final GlobalKey drawerKey = GlobalKey();
  final GlobalKey filterKey = GlobalKey();
  final GlobalKey searchKey = GlobalKey();
  List<GlobalKey> showcases = [];
  final _attendanceItemState = GlobalKey<AttendanceItemState>();
  BuildContext? attendanceContext;

  String selected = Strings.all;
  bool activeSearch = false;
  String search = "";

  @override
  void initState() {
    super.initState();

    List<String> finishedShowcases = GetIt.instance.get<StreamingSharedPreferences>().getStringList(Keys.finishedShowcases, defaultValue: []).getValue();
    if (!finishedShowcases.contains('attendanceScreen')) {
      showcases = [attendanceKey, searchKey, filterKey, drawerKey, createStudentKey, createPermissionKey];
    }

    if (showcases.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 400), () {
          ShowCaseWidget.of(attendanceContext!).startShowCase(showcases);
          List<String> finishedShowcases = GetIt.instance.get<StreamingSharedPreferences>().getStringList(Keys.finishedShowcases, defaultValue: []).getValue();
          finishedShowcases.add('attendanceScreen');
          GetIt.instance.get<StreamingSharedPreferences>().setStringList(Keys.finishedShowcases, finishedShowcases);
        });
      });
    }
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
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          attendanceContext = context;
          return WillPopScope(
            onWillPop: () async {
              if (activeSearch) {
                setState(() {
                  activeSearch = false;
                  search = '';
                });
                return false;
              }
              return true;
            },
            child: Scaffold(
              key: _scaffoldKey,
                appBar: AppBar(
                  leading: Showcase(
                    key: drawerKey,
                    description: Strings.drawerTooltip,
                    disposeOnTap: true,
                    onTargetClick: () {
                      setState(() {
                        showcases.remove(drawerKey);
                      });
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ),
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
                                      textCapitalization: TextCapitalization.words,
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
                                  child: Showcase(
                                    key: filterKey,
                                    description: Strings.filterStudentTooltip,
                                    targetPadding: const EdgeInsets.all(4),
                                    disposeOnTap: true,
                                    onTargetClick: () {
                                      setState(() {
                                        showcases.remove(filterKey);
                                      });
                                    },
                                    child: DropdownButton<String>(
                                      underline: Container(height: 1, color: Colors.black38,),
                                      isExpanded: true,
                                      value: selected,
                                      items: [const DropdownMenuItem(value: Strings.all, child: Text(Strings.all))] + state.groups.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selected = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                if (!activeSearch) IconButton(
                                  onPressed: () {
                                    setState(() {
                                      activeSearch = true;
                                    });
                                  },
                                  icon: Showcase(
                                    key: searchKey,
                                    description: Strings.searchStudentTooltip,
                                    targetShapeBorder: const CircleBorder(),
                                    targetPadding: const EdgeInsets.all(10),
                                    disposeOnTap: true,
                                    onTargetClick: () {
                                      setState(() {
                                        activeSearch = true;
                                        showcases.remove(searchKey);
                                      });
                                    },
                                    child: const Icon(Icons.search),
                                  ),
                                ),
                              ]
                          );
                        } else {
                          return const Text("Exception"); // TODO
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
                          // TODO: maybe move sorting to state or repository for better performance;
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          children: () {
                            var list = state.students
                                .where((student) =>
                            (selected == Strings.all ||
                                student.group == selected) && (!activeSearch ||
                                "${student.firstname} ${student.lastname}"
                                    .toLowerCase()
                                    .contains(search.toLowerCase()))).toList();

                            list.sort((a, b) => state.getStudent(a.studentId).compareTo(state.getStudent(b.studentId)));

                            List<Widget> result = [];
                            result.add(Showcase(
                                key: attendanceKey,
                                description: Strings.toggleAttendanceTooltip,
                                disposeOnTap: true,
                                onTargetClick: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShowStudentScreen(studentId: list.first.studentId),)).then((_) {
                                  setState(() {
                                    showcases.remove(attendanceKey);
                                    ShowCaseWidget.of(attendanceContext!).startShowCase(showcases);
                                  });
                                }),
                                onTargetLongPress: () => _attendanceItemState.currentState?.toggleAttendance(),
                                child: AttendanceItem(key: _attendanceItemState, studentId: list.first.studentId)));
                            list.removeAt(0);
                            for (var student in list) {
                              result.add(AttendanceItem(studentId: student.studentId));
                            }
                            return result;
                          } (),
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
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                          child: Row(
                            children: [
                              Align(alignment: Alignment.centerLeft, child: SimpleShadow(child: Opacity(opacity: 0.7, child: Image.asset(fit: BoxFit.fitHeight, "assets${Platform.pathSeparator}images${Platform.pathSeparator}building_blocks.png", height: 200)))),
                              const Spacer(),
                              SimpleShadow(child: Text(Strings.kinga, style: Theme.of(context).textTheme.headlineMedium,)),
                              const Spacer(),
                            ],
                          )),
                      Showcase(
                        key: createStudentKey,
                        description: Strings.createStudentTooltip,
                        disposeOnTap: true,
                        onTargetClick: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewStudentScreen())).then((_) {
                            setState(() {
                              showcases.remove(createStudentKey);
                              ShowCaseWidget.of(attendanceContext!).startShowCase(showcases);
                            });
                          });
                        },
                        child: ListTile(
                          title: const Text(Strings.newChild),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NewStudentScreen()));
                          },
                          leading: const Icon(Icons.add_circle_outline),
                        ),
                      ),
                      Showcase(
                        key: createPermissionKey,
                        description: Strings.createPermissionTooltip,
                        disposeOnTap: true,
                        onTargetClick: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ListPermissionsScreen(),)).then((_) {
                            setState(() {
                              showcases.remove(createPermissionKey);
                              ShowCaseWidget.of(attendanceContext!).startShowCase(showcases);
                            });
                          });
                        },
                        child: ListTile(
                          title: const Text(Strings.permission),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ListPermissionsScreen(),));
                          },
                          leading: const Icon(Icons.checklist),
                        ),
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
                        title: const Text(Strings.showHelp),
                        onTap: () {
                          GetIt.instance.get<StreamingSharedPreferences>().setStringList(Keys.finishedShowcases, []);
                          _scaffoldKey.currentState!.closeDrawer();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AttendanceScreen()));
                        },
                        leading: const Icon(Icons.help_outline),
                      ),
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
                          showDialog(context: context, builder: (context) => AlertDialog(
                            title: const Text(Strings.confirmLogout),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.of(context).pop(false);
                              }, child: const Text(Strings.cancel)),
                              TextButton(onPressed: () {
                                Navigator.of(context).pop(true);
                              }, child: const Text(Strings.confirm))
                            ],
                          ),).then((confirmed) {
                            if (confirmed ?? false) {
                              LoadingIndicatorDialog.show(context);
                              GetIt.I<InstitutionRepository>().leaveInstitution();
                              FirebaseAuth.instance.signOut().then((_) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            }
                          });
                        },
                        leading: const Icon(Icons.power_settings_new),
                      ),
                    ],
                  ),
                )
            ),
          );
        },
      )
    );
  }
}

class AttendanceItem extends StatefulWidget {
  const AttendanceItem({Key? key, required this.studentId}) : super(key: key);

  final String studentId;

  @override
  State<AttendanceItem> createState() => AttendanceItemState();
}

class AttendanceItemState extends State<AttendanceItem> {
  BuildContext? attendanceItemContext;

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
                            toggleAttendance();
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
                                        Uint8List? profileImage = state.getStudent(widget.studentId).profileImage;
                                        if (profileImage == null) {
                                          return Image.asset(
                                            'assets${Platform.pathSeparator}images${Platform.pathSeparator}squirrel.png',);
                                        } else {
                                          return Container(margin: const EdgeInsets.only(top: 5), clipBehavior: Clip.antiAlias, decoration: ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(44))), child: Image.memory(fit: BoxFit.fitHeight, profileImage));
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
                      child: Drop(image: Image.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}cupcake.png'), width: 35.0, height: 35.0, reversed: false,)
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Visibility(
                            visible: BlocProvider.of<StudentsCubit>(context).hasIncidences(widget.studentId),
                            child: Drop(image: Image.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}notification.png'), width: 35.0, height: 35.0, reversed: true,)
                        )
                  )
                ]
            );
        } else {
          throw Exception('Invalid State');
        }
      },
    );
  }

  void toggleAttendance() {
    BlocProvider.of<StudentsCubit>(context).toggleAttendance(widget.studentId);
  }
}