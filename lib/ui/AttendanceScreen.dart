import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinga/ui/ShowStudentScreen.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/constants/colors.dart';

import '../domain/students_cubit.dart';
import '../domain/entity/Attendance.dart';
import '../domain/entity/Student.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String selected = Strings.allGroups;
  bool activeSearch = false;

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
                if (state is StudentsLoading) {
                  return Text("loading..");
                } else if (state is StudentsLoaded) {
                  return Row(
                      children: [
                        if (activeSearch) Expanded(
                            child: TextField(
                              autofocus: true,
                              cursorColor: Colors.black38,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black38,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black38,
                                      )
                                  ),
                                  hintText: Strings.search,
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
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
                            items: [DropdownMenuItem(value: Strings.allGroups, child: Text(Strings.allGroups))] + state.groups.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
                            icon: Icon(Icons.search)
                        ),
                      ]
                  );
                } else {
                  return Text("Exception");
                }
  },
)

        ),
        body: BlocBuilder<StudentsCubit, StudentsState>(
          builder: (context, state) {
            if (state is StudentsInitial) {
              return Text("Init");
            } else if (state is StudentsLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Transform.scale(
                      scale: 2,
                      child: CircularProgressIndicator(
                        value: null,
                      ),
                    ),
                  )
                ]
              );
            } else if (state is StudentsLoaded) {
              return GridView(
                padding: EdgeInsets.all(10),
                children: state.students
                    .where((student) => student.group == selected || selected == Strings.allGroups)
                    .map((e) => AttendanceItem(
                    studentId: e.studentId, firstname: e.firstname))
                    .toList(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
              );
            } else {
              return Text("Else"); // TODO
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
                child: Center(child: Text(Strings.kinga))
              ),
              ListTile(
                title: const Text(Strings.newChild),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.add_circle_outline),
              ),
              ListTile(
                title: const Text(Strings.permission),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.checklist),
              ),
              Divider(),
              ListTile(
                title: const Text(Strings.support),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.question_answer),
              ),
              ListTile(
                title: const Text(Strings.feedback),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.chat_outlined),
              ),
              ListTile(
                title: const Text(Strings.impressum),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.domain),
              ),
              Divider(),
              ListTile(
                title: const Text(Strings.settings),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.settings),
              ),
              ListTile(
                title: const Text(Strings.logout),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.power_settings_new),
              ),
            ],
          ),
        )
    );
  }
}

class AttendanceItem extends StatefulWidget {
  AttendanceItem({Key? key, required this.studentId, required this.firstname}) : super(key: key);

  final String studentId;
  final String firstname;

  @override
  State<AttendanceItem> createState() => _AttendanceItemState();
}

class _AttendanceItemState extends State<AttendanceItem> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    Attendance attendance = Attendance("",DateTime.now().toIso8601String());

    return BlocBuilder<StudentsCubit, StudentsState>(
      builder: (context, state) {
        if (state is StudentsLoaded) {
          return Container(
              margin: EdgeInsets.all(10),
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
                      backgroundColor: state.getStudent(widget.studentId).attendances.length % 2 == 0
                          ? ColorSchemes.kingacolor
                          : ColorSchemes.errorColor
                  ),
                  child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: SvgPicture.asset(
                              'assets/images/hamster.svg',),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(widget.firstname),
                        )
                      ]
                  )
              )
          );
        } else {
          throw Exception('Invalid State');
        }
      },
    );
  }
}
