import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';

class PermissionItem extends StatefulWidget {
  const PermissionItem({Key? key, required this.studentId, this.onPressed}) : super(key: key);

  final String studentId;
  final VoidCallback? onPressed;

  @override
  State<PermissionItem> createState() => _PermissionItemState();
}

class _PermissionItemState extends State<PermissionItem> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentsCubit, StudentsState>(
      builder: (context, state) {
        if (state is StudentsLoaded) {
          var student = state.getStudent(widget.studentId);
          return Stack(
              children: [
                Container(
                    //margin: const EdgeInsets.all(10),
                    //margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        onPressed: widget.onPressed,
                        style: TextButton.styleFrom(
                          elevation: 0,
                          /*
                          side: const BorderSide(color: Colors.black54),
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(64.0),
                          ),
                           */
                          backgroundColor: Colors.transparent,

                        ),
                        child: Column(
                            children: [
                              Expanded(
                                child: () {
                                  Uint8List? profileImage = state.getStudent(widget.studentId).profileImage;
                                  if (profileImage == null) {
                                    return Image.asset('assets/images/squirrel.png',);
                                  } else {
                                    return Container(margin: const EdgeInsets.only(top: 5, left: 0, right: 0), clipBehavior: Clip.antiAlias, decoration: ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(44))), child: Image.memory(fit: BoxFit.fitHeight, profileImage));
                                  }
                                } (),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Column(
                                  children: [
                                    Text(overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, "${student.firstname}", style: const TextStyle(color: Colors.black),),
                                    Text(overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, "${student.lastname}", style: const TextStyle(color: Colors.black),),
                                  ],
                                ),
                              )
                            ]
                        )
                    )
                ),
              ]
          );
        } else {
          throw Exception('Invalid State'); // TODO
        }
      },
    );
  }
}
