import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/domain/StudentService.dart';
import 'package:kinga/ui/ShowStudentScreen.dart';

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
  StudentService studentService = GetIt.I<StudentService>();
  String selected = 'Alle';
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
            title: Row(
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
                            hintText: 'Suche',
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
                      items: [DropdownMenuItem(value: 'Alle', child: Text('Alle'))] + studentService.getAvailableGroups().map((e) =>
                          DropdownMenuItem(value: e, child: Text(e))).toList(),
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
            )

        ),
        body: GridView(
          padding: EdgeInsets.all(10),
          children: studentService.getAllStudents().map((e) => AttendanceItem(studentId: e.studentId, firstname: e.firstname)).toList(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
        ),

        drawer: Drawer(
          backgroundColor: Theme.of(context).backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: Center(child: Text('KinGa'))
              ),
              ListTile(
                title: const Text('Neues Kind'),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.add_circle_outline),
              ),
              ListTile(
                title: const Text('Berechtigungen'),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.checklist),
              ),
              Divider(),
              ListTile(
                title: const Text('Support'),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.question_answer),
              ),
              ListTile(
                title: const Text('Feedback'),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.chat_outlined),
              ),
              ListTile(
                title: const Text('Impressum'),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.domain),
              ),
              Divider(),
              ListTile(
                title: const Text('Einstellungen'),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.settings),
              ),
              ListTile(
                title: const Text('Ausloggen'),
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

class AttendanceItem extends StatelessWidget {
  const AttendanceItem({Key? key, required this.studentId, required this.firstname}) : super(key: key);

  final String studentId;
  final String firstname;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowStudentScreen(studentId: studentId,)));
        },
          style: TextButton.styleFrom(shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(64.0)
        )),
        child: Column(
            children: [
              Expanded(
                child: Container(
                  child: SvgPicture.asset('assets/images/hamster.svg',),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(firstname),
              )
            ]
        )
      )
    );
  }
}
