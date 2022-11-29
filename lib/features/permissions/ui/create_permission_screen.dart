import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/permissions/domain/permission_service.dart';
import 'package:kinga/features/permissions/ui/list_permissions_screen.dart';
import 'package:kinga/features/permissions/ui/permission_item_widget.dart';
import 'package:kinga/shared/loading_indicator_dialog.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _newPermissionTextFieldFocus = FocusNode();
  late final StreamSubscription<bool> _keyboardSubscription;

  _CreatePermissionScreenState() {
    _students = _studentService.students.toList()..sort();
    for (var student in _students) {_studentPermissions[student.studentId] = true;}
  }

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription = keyboardVisibilityController.onChange.listen((bool isVisible) {
      if (!isVisible) {
        _newPermissionTextFieldFocus.unfocus();
      }
    });

  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    super.dispose();
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
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          if (_newPermissionTextFieldFocus.hasFocus) {
            _newPermissionTextFieldFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              getQuickSelectionButton(),
            ],
            title: Form(key: _formKey, child: TextFormField(
              focusNode: _newPermissionTextFieldFocus,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return ""; // empty error message
                } else {
                  return null;
                }
              },
              controller: _newPermissionController,
              cursorColor: Colors.black,
              autofocus: true,
              decoration: const InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.only(left: 10, top: 7, bottom: 7),
                isDense: true,
                hintText: Strings.newPermissionHint,
                focusedBorder: UnderlineInputBorder(),
              ),
            )),
          ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: const Text(Strings.createNewPermission),
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
                      LoadingIndicatorDialog.show(context);
                      _permissionService.createPermission(_newPermissionController.text.trim(), _studentPermissions).then((value) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ListPermissionsScreen(),));
                      });
                    }
                  });
                } else {
                  _newPermissionTextFieldFocus.unfocus();
                  _newPermissionTextFieldFocus.requestFocus();
                }
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
      ),
    );
  }

  Widget getQuickSelectionButton() {
    if (_studentPermissions.values.contains(false)) {
      if (_studentPermissions.values.contains(true)) {
        // mixed state
        return IconButton(icon: const Icon(Icons.indeterminate_check_box_outlined), onPressed: () {
          setState(() {
            _studentPermissions.updateAll((key, value) => false);
          });
        },);
      } else {
        // none selected
        return IconButton(icon: const Icon(Icons.check_box_outline_blank), onPressed: () {
          setState(() {
            _studentPermissions.updateAll((key, value) => true);
          });
        },);
      }
    } else {
      // all selected
      return IconButton(icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_box_outlined),
        ],
      ), onPressed: () {
        setState(() {
          _studentPermissions.updateAll((key, value) => false);
        });
      },);
    }
  }

}