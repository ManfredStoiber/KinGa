import 'dart:typed_data';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/features/observations/ui/observation_of_the_week_bar.dart';
import 'package:kinga/features/permissions/ui/list_permissions_screen.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/ui/new_student_screen.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/ui/show_student_screen.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/ui/widgets/drop.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:kinga/util/shared_prefs_utils.dart';
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

  final AnalyticsService _analyticsService = GetIt.I<AnalyticsService>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> allShowcases = [Keys.attendanceKey, Keys.searchKey, Keys.filterKey, Keys.drawerKey, Keys.createStudentKey, Keys.createPermissionKey];
  Map<String, GlobalKey> showcaseKeys = {};
  List<GlobalKey> showcases = [];
  List<String> locallyFinishedShowcases = [];
  final _attendanceItemState = GlobalKey<AttendanceItemState>();
  BuildContext? attendanceContext;

  String selected = Strings.all;
  bool activeSearch = false;
  String search = "";

  @override
  void initState() {
    super.initState();
    List<String> finishedShowcases = GetIt.instance.get<StreamingSharedPreferences>().getStringList(Keys.finishedShowcases, defaultValue: []).getValue();
    List<String> missingShowcases = List.from(allShowcases.where((element) => !finishedShowcases.contains(element),));
    for (var showcase in missingShowcases) {
      showcaseKeys[showcase] = GlobalKey();
      var key = showcaseKeys[showcase];
      if (key != null) {
        showcases.add(key);
      }
    }

    if (showcases.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 400), () {
          ShowCaseWidget.of(attendanceContext!).startShowCase(showcases);
        });
      });
    }

    selected = GetIt.I<StreamingSharedPreferences>().getString(Keys.selectedGroup, defaultValue: Strings.all).getValue();
  }

  @override
  void dispose() {
    super.dispose();
    List<String> finishedShowcases = GetIt.instance.get<StreamingSharedPreferences>().getStringList(Keys.finishedShowcases, defaultValue: []).getValue();
    finishedShowcases.addAll(locallyFinishedShowcases);
    GetIt.instance.get<StreamingSharedPreferences>().setStringList(Keys.finishedShowcases, finishedShowcases);
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
      autoPlay: true,
      enableAutoPlayLock: true,
      autoPlayDelay: const Duration(days: 42),
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
                      key: showcaseKeys[Keys.drawerKey] ?? GlobalKey(),
                      description: Strings.drawerTooltip,
                      disposeOnTap: true,
                      onToolTipClick: () {
                        setState(() {
                          continueShowcase(Keys.drawerKey);
                        });
                      },
                      onTargetClick: () {
                        setState(() {
                          ShowCaseWidget.of(attendanceContext!).deactivate();
                          _scaffoldKey.currentState!.openDrawer();
                          Future.delayed(const Duration(milliseconds: 100), ).then((value) async {
                            while (!(_scaffoldKey.currentState?.isDrawerOpen ?? false)) {
                              await Future.delayed(const Duration(milliseconds: 100));
                            }
                            await Future.delayed(const Duration(milliseconds: 400));
                            continueShowcase(Keys.drawerKey);
                          },);
                        });
                      },
                      child: IconButton(
                        onPressed: () {
                          if (showcases.isEmpty) {
                            _scaffoldKey.currentState!.openDrawer();
                          } else {
                            setState(() {
                              ShowCaseWidget.of(attendanceContext!).deactivate();
                              _scaffoldKey.currentState!.openDrawer();
                              Future.delayed(const Duration(milliseconds: 100), ).then((value) async {
                                while (!(_scaffoldKey.currentState?.isDrawerOpen ?? false)) {
                                  await Future.delayed(const Duration(milliseconds: 100));
                                }
                                await Future.delayed(const Duration(milliseconds: 400));
                                continueShowcase(Keys.drawerKey);
                              },);
                            });
                          }
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
                                    key: showcaseKeys[Keys.filterKey] ?? GlobalKey(),
                                    description: Strings.filterStudentTooltip,
                                    targetPadding: const EdgeInsets.all(4),
                                    disposeOnTap: true,
                                    onToolTipClick: () {
                                      setState(() {
                                        continueShowcase(Keys.filterKey);
                                      });
                                    },
                                    onTargetClick: () {
                                      setState(() {
                                        continueShowcase(Keys.filterKey);
                                      });
                                    },
                                    child: DropdownButton<String>(
                                      underline: Container(height: 1, color: Colors.black38,),
                                      isExpanded: true,
                                      value: state.groups.contains(selected)? selected : Strings.all,
                                      items: [const DropdownMenuItem(value: Strings.all, child: Text(Strings.all))] + state.groups.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selected = newValue!;
                                          GetIt.I<StreamingSharedPreferences>().setString(Keys.selectedGroup, newValue);
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
                                    key: showcaseKeys[Keys.searchKey] ?? GlobalKey(),
                                    description: Strings.searchStudentTooltip,
                                    targetShapeBorder: const CircleBorder(),
                                    targetPadding: const EdgeInsets.all(10),
                                    disposeOnTap: true,
                                    onToolTipClick: () {
                                      setState(() {
                                        continueShowcase(Keys.searchKey);
                                      });
                                    },
                                    onTargetClick: () {
                                      setState(() {
                                        continueShowcase(Keys.searchKey);
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
                    ),

                ),
                body: BlocBuilder<StudentsCubit, StudentsState>(
                    builder: (context, state) {
                      if (state is StudentsInitial || state is StudentsLoading) {
                        return const LoadingIndicator();
                      } else if (state is StudentsEmpty) {
                        return Text("No Children");
                      } else if (state is StudentsLoaded) {
                        return Column(
                          children: [
                            ObservationOfTheWeekBar(),
                            Expanded(
                              child: SafeArea(
                                child: GridView(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                    if (list.isNotEmpty) {
                                      result.add(Showcase(
                                          key: showcaseKeys[Keys.attendanceKey] ?? GlobalKey(),
                                          description: Strings.toggleAttendanceTooltip,
                                          disposeOnTap: true,
                                          onToolTipClick: () {
                                            setState(() {
                                              continueShowcase(Keys.attendanceKey);
                                            });
                                          },
                                          onTargetClick: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShowStudentScreen(studentId: list.first.studentId),)).then((_) {
                                            setState(() {
                                              continueShowcase(Keys.attendanceKey);
                                            });
                                          }),
                                          onTargetLongPress: () => _attendanceItemState.currentState?.toggleAttendance(),
                                          child: AttendanceItem(key: _attendanceItemState, studentId: list.first.studentId)));
                                      list.removeAt(0);

                                      for (var student in list) {
                                        result.add(AttendanceItem(studentId: student.studentId));
                                      }
                                    }

                                    return result;
                                  } (),
                                ),
                              ),
                            ),
                          ],
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
                          )
                      ),
                      Showcase(
                        key: showcaseKeys[Keys.createStudentKey] ?? GlobalKey(),
                        description: Strings.createStudentTooltip,
                        disposeOnTap: true,
                        onToolTipClick: () {
                          setState(() {
                            continueShowcase(Keys.createStudentKey);
                          });
                        },
                        onTargetClick: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewStudentScreen())).then((_) {
                            setState(() {
                              continueShowcase(Keys.createStudentKey);
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
                        key: showcaseKeys[Keys.createPermissionKey] ?? GlobalKey(),
                        description: Strings.createPermissionTooltip,
                        disposeOnTap: true,
                        onToolTipClick: () {
                          setState(() {
                            continueShowcase(Keys.createPermissionKey);
                          });
                        },
                        onTargetClick: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ListPermissionsScreen(),)).then((_) {
                            setState(() {
                              continueShowcase(Keys.createPermissionKey);
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
                      /*
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
                       */
                      const Divider(),
                      ListTile(
                        title: const Text(Strings.showHelp),
                        onTap: () {
                          _analyticsService.logEvent(name: Keys.analyticsShowHelp);
                          GetIt.instance.get<StreamingSharedPreferences>().setStringList(Keys.finishedShowcases, []);
                          _scaffoldKey.currentState!.closeDrawer();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AttendanceScreen()));
                        },
                        leading: const Icon(Icons.help_outline),
                      ),
                      /*
                      ListTile(
                        title: const Text(Strings.settings),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        leading: const Icon(Icons.settings),
                      ),
                       */
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
      ),
    );
  }

  void continueShowcase(String key) {
    showcases.remove(showcaseKeys[key]);
    locallyFinishedShowcases.add(key);
    if (key != Keys.createPermissionKey) {
      ShowCaseWidget.of(attendanceContext!).startShowCase(showcases);
    }
    SharedPrefsUtils.updateFinishedShowcases(key);
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
          StudentsCubit cubit = BlocProvider.of<StudentsCubit>(context);
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () {
                        GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsShowStudent);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                ShowStudentScreen(studentId: widget.studentId,)));
                      },
                      onLongPress: () {
                        GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsToggleAttendance);
                        toggleAttendance();
                      },
                      style: TextButton.styleFrom(
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(64.0),
                            side: cubit.isAbsent(widget.studentId) && false ? BorderSide() : BorderSide.none
                          ),
                          //shadowColor: Colors.transparent,
                          backgroundColor: (){
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
                                      // check if image uses alpha channel
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
              Align(
                alignment: Alignment.topLeft,
                child: Visibility(
                    visible: BlocProvider.of<StudentsCubit>(context).hasBirthday(widget.studentId),
                    child: Drop(image: Image.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}cupcake.png'), width: 35.0, height: 35.0, reversed: false,)
                ),
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