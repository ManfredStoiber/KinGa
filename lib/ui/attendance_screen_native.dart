import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:kinga/constants/strings.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/ui/widgets/drop.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:kinga/ui/widgets/virtual_keyboard/virtual_keyboard_multi_language.dart';

import 'bloc/students_cubit.dart';
import 'package:flutter/cupertino.dart' as cupertino;

class AttendanceScreenNative extends StatefulWidget {
  const AttendanceScreenNative({Key? key}) : super(key: key);

  @override
  State<AttendanceScreenNative> createState() => _AttendanceScreenNativeState();
}

class _AttendanceScreenNativeState extends State<AttendanceScreenNative> {

  String selected = Strings.all;
  bool activeSearch = false;
  bool shiftEnabled = false;
  bool searchFocus = true;
  FocusNode searchFocusNode = FocusNode();
  TextSelection searchTextSelection = TextSelection.collapsed(offset: 0);
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {

    StudentService studentService = GetIt.I<StudentService>();

    // start rs232 rfid reader
    if (Platform.isLinux || Platform.isWindows) {
      Future<Process> processFuture;
      if (Platform.isLinux) {
        processFuture = Process.start("/usr/bin/python", ['/home/pi/rfid_reader.py']);
      } else {
        processFuture = Process.start("python c:\\users\\public\\rfid_reader.py", [], runInShell: true, );
      }
      processFuture.then((process) {
        process.stderr.transform(utf8.decoder).forEach((err) {
          cupertino.debugPrint(err);
        });
        process.stdout.transform(utf8.decoder).forEach((rfid) {
          rfid = rfid.trim();
          studentService.registerRfidAttendance(rfid, false).then((value) {});
        });
      });
    }

    // start usb rfid reader
    if (Platform.isLinux || Platform.isWindows) {
      Future<Process> processFuture;
      if (Platform.isLinux) {
        processFuture = Process.start("/usr/bin/python", ['/home/pi/rfid_reader_usb.py']);
      } else {
        processFuture = Process.start("python c:\\users\\public\\rfid_reader_usb.py", [], runInShell: true, );
      }
      processFuture.then((process) {
        process.stderr.transform(utf8.decoder).forEach((err) {
          cupertino.debugPrint(err);
        });
        process.stdout.transform(utf8.decoder).forEach((rfid) {
          rfid = rfid.trim();
          studentService.registerRfidAttendance(rfid, true).then((value) {});
        });
      });
    }

    searchController.addListener(() {
      if (searchController.selection.isValid) {
        searchTextSelection = searchController.selection;
      }
    });

    searchFocusNode.addListener(() {
      if (searchFocusNode.hasFocus) {
        setState(() {
          searchFocus = true;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: BlocBuilder<StudentsCubit, StudentsState>(
              builder: (context, state) {
                if (state is StudentsInitial || state is StudentsLoading) {
                  return const Text(Strings.loading);
                } else if (state is StudentsLoaded) {
                  return Row(
                      children: [
                        if (activeSearch) Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                setState(() {
                                });
                              },
                              autofocus: true,
                              focusNode: searchFocusNode,
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
                            items: [const DropdownMenuItem(value: Strings.all, child: Text(Strings.all))] + state.groups.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      searchFocus = false;
                    });
                  },
                      child: GridView(
                        padding: const EdgeInsets.all(10),
                        // TODO: maybe move sorting to state or repository for better performance;
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                        ),
                        children: state.students
                            .where((student) =>
                        (selected == Strings.all ||
                            student.group == selected) && (!activeSearch ||
                            "${student.firstname} ${student.lastname}"
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase())))
                            .map((e) =>
                            AttendanceItem(studentId: e.studentId, onPressed: () => setState(() {
                              searchFocus = false;
                            }),))
                            .toList()
                          ..sort((a, b) => state.getStudent(a.studentId).compareTo(state.getStudent(b.studentId))),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: searchFocus && activeSearch,
                    child: VirtualKeyboard(height: 150.0, type: VirtualKeyboardType.Alphanumeric, defaultLayouts: [VirtualKeyboardDefaultLayouts.GermanWithoutSpecialCharacters], onKeyPress: (VirtualKeyboardKey key) {
                      bool keepFocus = true;
                      if (key.keyType == VirtualKeyboardKeyType.String) {
                        if (searchFocus) {
                          var selection = TextSelection.collapsed(offset: searchTextSelection.start + 1);
                          var text = searchController.text;
                          searchController.text = text.substring(0, searchTextSelection.start) + (shiftEnabled ? key.capsText ?? "" : key.text ?? "") + text.substring(searchTextSelection.end);
                          // set cursor to correct position
                          searchController.value = TextEditingValue(
                              text: searchController.text,
                              selection: selection
                          );
                        }
                      } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                        switch (key.action) {
                          case VirtualKeyboardKeyAction.Backspace:
                            if (searchFocus) {
                              if (searchController.text.isEmpty) return;
                              var selection = searchTextSelection;
                              var text = searchController.text;
                              if (searchTextSelection.isCollapsed && searchTextSelection.start != 0) {
                                searchController.text = text.substring(0, searchTextSelection.start - 1) + text.substring(searchTextSelection.start);
                                selection = TextSelection.collapsed(offset: searchTextSelection.start - 1);
                              } else if (!searchTextSelection.isCollapsed) {
                                searchController.text = text.substring(0, searchTextSelection.start) + text.substring(searchTextSelection.end);
                                selection = TextSelection.collapsed(offset: searchTextSelection.start);
                              }
                              // set cursor to correct position
                              searchController.value = TextEditingValue(
                                  text: searchController.text,
                                  selection: selection
                              );
                            }
                            break;
                          case VirtualKeyboardKeyAction.Space:
                            var selection = TextSelection.collapsed(offset: searchTextSelection.start + 1);
                            var text = searchController.text;
                            searchController.text = text.substring(0, searchTextSelection.start) + (shiftEnabled ? key.capsText ?? "" : key.text ?? "") + text.substring(searchTextSelection.end);
                            // set cursor to correct position
                            searchController.value = TextEditingValue(
                                text: searchController.text,
                                selection: selection
                            );
                            break;
                          case VirtualKeyboardKeyAction.Return:
                            searchFocus = false; // remove focus
                            keepFocus = false;
                            break;
                          case VirtualKeyboardKeyAction.Shift:
                            shiftEnabled = !shiftEnabled;
                            break;
                          default:
                        }
                      }

                      if (keepFocus) {
                        searchFocusNode.requestFocus();
                      }
                      setState(() { });
                    },),
                  )
                ],
              );
            } else {
              return const Text("Exception"); // TODO
            }
          }
        ),
    );
  }
}

class AttendanceItem extends StatefulWidget {
  const AttendanceItem({Key? key, required this.studentId, this.onPressed}) : super(key: key);

  final String studentId;
  final Function()? onPressed;

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
                      if (widget.onPressed != null) {
                        widget.onPressed!();
                      }
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
                              Uint8List? profileImage = state.getStudent(widget.studentId).profileImage;
                              if (profileImage == null || profileImage.isEmpty) {
                                //return SvgPicture.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}hamster.svg',);
                                return Container(margin: const EdgeInsets.only(top: 5), clipBehavior: Clip.antiAlias, decoration: ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(44))), child: Image.asset('assets/images/squirrel.png', fit: BoxFit.fitHeight));
                                //return Container(margin: const EdgeInsets.only(top: 5), clipBehavior: Clip.antiAlias, decoration: ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(44))), child: SvgPicture.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}hamster.svg',));
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
              ))
            ]
          );
        } else {
          throw Exception('Invalid State');
        }
      },
    );
  }
}