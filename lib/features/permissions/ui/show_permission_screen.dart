import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/permissions/domain/permission_service.dart';
import 'package:kinga/features/permissions/ui/list_permissions_screen.dart';
import 'package:kinga/features/permissions/ui/permission_item_widget.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ShowPermissionScreen extends StatefulWidget {

  final String permission;

  const ShowPermissionScreen(this.permission, {Key? key}) : super(key: key);

  @override
  State<ShowPermissionScreen> createState() => _ShowPermissionScreenState();
}

class _ShowPermissionScreenState extends State<ShowPermissionScreen> {

  final StudentService _studentService = GetIt.I<StudentService>();
  final PermissionService _permissionService = GetIt.I<PermissionService>();

  List<Student> students = [];
  Map<String, bool> groupSelection = {};
  bool permitted = false;
  bool onlyAttendantStudents = true;

  @override
  void initState() {
    super.initState();
    for (var group in _studentService.groups) {
      groupSelection[group] = true;
    }
    students = _studentService.students.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.permission),
        actions: [
          IconButton(icon: const Icon(Icons.delete_forever), onPressed: () {
            showDialog(context: context, builder: (context) => AlertDialog(
              title: const Text(Strings.confirmDeletePermission),
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
                _permissionService.deletePermission(widget.permission).then((value) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ListPermissionsScreen(),));
                });
              }
            });
          },),
        ],
      ),
      body: Column(children: [
        Row(children: [
          Container(margin: const EdgeInsets.only(left: 5, top: 5, right: 5), child: const Icon(Icons.groups)),
          Container(margin: const EdgeInsets.only(left: 5, top: 5), child: const Text(Strings.selectGroups))
        ],),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: (){
            List<Widget> chips = [];
            for (var group in groupSelection.keys.toList()..sort()) {
              chips.add(Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: FilterChip(
                  selectedColor: ColorSchemes.kingacolor,
                  label: Text(group),
                  selected: groupSelection[group] ?? false,
                  onSelected: (selected) {
                    setState(() {
                      groupSelection[group] = !(groupSelection[group] ?? false);
                    });
                  },
                ),
              ));
            }
            return chips;
          }(),),
        ),
        const Divider(height: 1,),
        Row(
          children: [
            Row(
              children: [
                Container(margin: const EdgeInsets.all(5), child: const Icon(Icons.filter_alt)),
                Container(margin: const EdgeInsets.all(5), child: const Text(Strings.selectFilter)),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterChip(
                    avatar: CircleAvatar(backgroundColor: Colors.transparent, foregroundColor: Colors.black, child: permitted ? const Icon(Icons.check) : const Icon(Icons.close),),
                    label: Text(permitted ? Strings.permitted : Strings.prohibited),
                    backgroundColor: ColorSchemes.errorColor,
                    selected: permitted,
                    selectedColor: ColorSchemes.kingacolor,
                    showCheckmark: false,
                    onSelected: (selected) {
                      setState(() {
                        permitted = !permitted;
                      });
                    },
                  ),
                  FilterChip(
                    //avatar: CircleAvatar(backgroundColor: Colors.transparent, foregroundColor: Colors.black, child: permitted ? Icon(Icons.check) : Icon(Icons.close),),
                    label: const Text(Strings.filterAttendant),
                    selected: onlyAttendantStudents,
                    selectedColor: ColorSchemes.kingacolor,
                    onSelected: (selected) {
                      setState(() {
                        onlyAttendantStudents = !onlyAttendantStudents;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 1,),
        Expanded(
          child: () {
            var list = (students..sort()).where((student) =>
            (groupSelection[student.group] ?? false) &&
                student.permissions.any((permission) => permission == widget.permission) == permitted &&
                (BlocProvider.of<StudentsCubit>(context).isAttendant(student.studentId) || !onlyAttendantStudents)
            ).map((student) => PermissionItem(studentId: student.studentId)).toList();

            if (list.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(margin: const EdgeInsets.all(30), width: 200, child: SimpleShadow(child: Opacity(opacity: 0.4, child: Image.asset('assets/images/no_permissions.png')))),
                  Text(Strings.noPermissionsFiltered, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
                  Container(margin: const EdgeInsets.all(20), child: Text(Strings.noPermissionsFilteredDescription, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
                ],
              );
            }

            return GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              children: list,
            );
          } (),
        )
      ]),
    );
  }
}