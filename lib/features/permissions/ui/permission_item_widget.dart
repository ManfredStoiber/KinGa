import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
          return Stack(
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: widget.onPressed,
                        style: TextButton.styleFrom(
                          elevation: 0,
                          side: const BorderSide(color: Colors.black54),
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(64.0),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Column(
                            children: [
                              Expanded(
                                child: () {
                                  if (state.getStudent(widget.studentId).profileImage == null) {
                                    return SvgPicture.asset('assets/images/hamster.svg',);
                                  } else {
                                    return Container(margin: const EdgeInsets.only(top: 5), clipBehavior: Clip.antiAlias, decoration: ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(44))), child: Image.memory(fit: BoxFit.fitHeight, state.getStudent(widget.studentId).profileImage));
                                  }
                                } (),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Text(state.getStudent(widget.studentId).firstname, style: const TextStyle(color: Colors.black),),
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
