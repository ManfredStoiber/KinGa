import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/permissions/domain/permission_service.dart';
import 'package:kinga/features/permissions/ui/list_permissions_screen.dart';
import 'package:kinga/features/permissions/ui/permission_item_widget.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';

class CreatePermissionScreen extends StatefulWidget {
  const CreatePermissionScreen({Key? key}) : super(key: key);

  @override
  State<CreatePermissionScreen> createState() => _CreatePermissionScreenState();
}

class _CreatePermissionScreenState extends State<CreatePermissionScreen> {

  final StudentService _studentService = GetIt.I<StudentService>();
  final PermissionService _permissionService = GetIt.I<PermissionService>();

  late final List<Student> _students;
  final Map<String, bool> _studentPermissions = {};
  final TextEditingController _newPermissionController = TextEditingController();
  final GlobalKey<FormState> permissionNameKey = GlobalKey<FormState>();

  bool isEdited = false;

  _CreatePermissionScreenState() {
    _students = _studentService.students.toList()..sort();
    for (var student in _students) {_studentPermissions[student.studentId] = true;}
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPermissionDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(context: context, builder: (context) => AlertDialog(
          title: const Text(Strings.confirmDiscardNewPermission),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop(false);
            }, child: const Text(Strings.cancel)),
            TextButton(onPressed: () {
              Navigator.of(context).pop(true);
            }, child: const Text(Strings.confirm))
          ],
        ),);
      },
      child: Scaffold(
          appBar: AppBar(
            actions: [
              getQuickSelectionButton(),
          ],
          title: TextField(
            onTap: () => _showPermissionDialog(),
            controller: _newPermissionController,
            mouseCursor: SystemMouseCursors.none,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              errorStyle: TextStyle(height: 0),
              contentPadding: EdgeInsets.only(left: 10, top: 7, bottom: 7),
              isDense: true,
              hintText: Strings.newPermissionHint,
              focusedBorder: UnderlineInputBorder(),
            ),
          ),
        ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.check),
            onPressed: () {
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text('${Strings.createNewPermission} \'${_newPermissionController.text}\' anlegen?'),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.of(context).pop(false);
                  }, child: const Text(Strings.cancel)),
                  TextButton(onPressed: () {
                    Navigator.of(context).pop(true);
                  }, child: const Text(Strings.confirm))
                ],
              ),).then((confirmed) {
                if (confirmed) {
                  LoadingIndicatorDialog.show(context, Strings.loadCreatePermission);
                  _permissionService.createPermission(_newPermissionController.text.trim(), _studentPermissions).then((value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ListPermissionsScreen(),));
                  });
                }
              });
            },
          ),
          body: Column(
            children: [
              Expanded(
                child: GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                children: _students.map((student) => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    PermissionItem(studentId: student.studentId, onPressed: () {
                      setState(() {
                        _studentPermissions[student.studentId] = !_studentPermissions[student.studentId]!;
                      });
                    },),
                    AnimatedOpacity(
                      opacity: _studentPermissions[student.studentId]! ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: const CircleBorder(), value: true, onChanged: (value) {

                        },),
                      ),
                    )
                  ],
                )).toList(),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget getQuickSelectionButton() {
    if (_studentPermissions.values.contains(false)) {
      if (_studentPermissions.values.contains(true)) {
        // mixed state
        return TextButton(
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: const Text(Strings.deselectAll,
                      style: TextStyle(color: Colors.black)
                  )
              ),
              const Icon(Icons.indeterminate_check_box_outlined, color: Colors.black),
            ],
          ), onPressed: () {
          setState(() {
            _studentPermissions.updateAll((key, value) => false);
          });
        },);
      } else {
        // none selected
        return TextButton(
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: const Text(Strings.selectAll,
                      style: TextStyle(color: Colors.black)
                  )
              ),
              const Icon(Icons.check_box_outline_blank, color: Colors.black),
            ],
          ), onPressed: () {
          setState(() {
            _studentPermissions.updateAll((key, value) => true);
          });
        },);
      }
    } else {
      // all selected
      return TextButton(
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.only(right: 5),
                child: const Text(Strings.deselectAll,
                    style: TextStyle(color: Colors.black)
                )
            ),
            const Icon(Icons.check_box_outlined, color: Colors.black),
          ],
        ), onPressed: () {
        setState(() {
          _studentPermissions.updateAll((key, value) => false);
        });
      },);
    }
  }

  void _showPermissionDialog() {
    showDialog(context: context, builder: (context) {
      TextEditingController permissionNameController = TextEditingController();
      permissionNameController.text = _newPermissionController.text;

      return AlertDialog(
        title: const Text(Strings.newPermissionHint),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
            if (!isEdited) Navigator.of(context).pop();
          }, child: const Text(Strings.cancel)),
          TextButton(onPressed: () {
            if (permissionNameKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(permissionNameController.text);
              isEdited = true;
            }
          }, child: const Text(Strings.confirm))
        ],
        content: Form(
          key: permissionNameKey,
          child: TextFormField(
            controller: permissionNameController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: Strings.label),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${Strings.label} ${Strings.requiredFieldMessage}';
              } else {
                return null;
              }
            },
          ),
        ),
      );},
    ).then((result) {
      if (result != null) {
        setState(() {
          _newPermissionController.text = result;
        });
      }
    });
  }
}