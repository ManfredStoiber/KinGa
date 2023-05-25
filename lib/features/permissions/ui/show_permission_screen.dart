import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/routes.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/features/permissions/domain/permission_service.dart';
import 'package:kinga/features/permissions/ui/permission_item_widget.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';
import 'package:kinga/util/shared_prefs_utils.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

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
  bool permitted = true;
  bool onlyAttendantStudents = false;

  GlobalKey filterPermissionKey = GlobalKey();
  List<GlobalKey> showcases = [];
  List<String> locallyFinishedShowcases = [];
  BuildContext? showPermissionContext;

  @override
  void initState() {
    super.initState();

    List<String> finishedShowcases = GetIt.instance.get<StreamingSharedPreferences>().getStringList(Keys.finishedShowcases, defaultValue: []).getValue();
    if (!finishedShowcases.contains(Keys.filterPermissionKey)) {
      showcases.add(filterPermissionKey);
    }

    if (showcases.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 400), () {
          ShowCaseWidget.of(showPermissionContext!).startShowCase(showcases);
        });
      });
    }

    var selectedGroup = GetIt.I<StreamingSharedPreferences>().getString(Keys.selectedGroup, defaultValue: "").getValue();
    if (selectedGroup == "" || selectedGroup == Strings.all) {
      for (var group in _studentService.groups) {
        groupSelection[group] = true;
      }
    } else {
      for (var group in _studentService.groups) {
        groupSelection[group] = false;
      }
      groupSelection[selectedGroup] = true;
    }
    students = _studentService.students.toList();
  }

  @override
  void dispose() {
    super.dispose();
    List<String> finishedShowcases = GetIt.instance.get<StreamingSharedPreferences>().getStringList(Keys.finishedShowcases, defaultValue: []).getValue();
    finishedShowcases.addAll(locallyFinishedShowcases);
    GetIt.instance.get<StreamingSharedPreferences>().setStringList(Keys.finishedShowcases, finishedShowcases);
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      autoPlay: true,
      enableAutoPlayLock: true,
      autoPlayDelay: const Duration(days: 42),
      builder: Builder(
        builder: (context) {
          showPermissionContext = context;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.permission),
              actions: [
                IconButton(icon: const Icon(Icons.delete_forever), onPressed: () {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: const Text(Strings.confirmDeletePermission),
                    actions: [
                      TextButton(onPressed: () {
                        context.pop(false);
                      }, child: const Text(Strings.cancel)),
                      TextButton(onPressed: () {
                        context.pop(true);
                      }, child: const Text(Strings.confirm))
                    ],
                  ),).then((confirmed) {
                    if (confirmed ?? false) {
                      LoadingIndicatorDialog.show(context, Strings.loadDeletePermission);
                      _permissionService.deletePermission(widget.permission).then((value) {
                        context.goNamed(Routes.listPermissions);
                      });
                    }
                  });
                },),
              ],
            ),
            body: Column(children: [
              Showcase(
                key: filterPermissionKey,
                description: Strings.filterPermissionsTooltip,
                disposeOnTap: true,
                onToolTipClick: () {
                  setState(() {
                    showcases.remove(filterPermissionKey);
                    locallyFinishedShowcases.add(Keys.filterPermissionKey);
                    SharedPrefsUtils.updateFinishedShowcases(Keys.filterPermissionKey);
                  });
                },
                onTargetClick: () {
                  setState(() {
                    showcases.remove(filterPermissionKey);
                    locallyFinishedShowcases.add(Keys.filterPermissionKey);
                    SharedPrefsUtils.updateFinishedShowcases(Keys.filterPermissionKey);
                  });
                },
                child: Column(
                  children: [
                    Row(children: [
                      Container(margin: const EdgeInsets.only(left: 5, top: 5, right: 5), child: const Icon(Icons.groups)),
                      Container(margin: const EdgeInsets.only(left: 5, top: 5), child: const Text(Strings.selectGroups))
                    ],),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: (){
                        List<Widget> selectedChips = [];
                        List<Widget> unselectedChips = [];
                        for (var group in groupSelection.keys.toList()..sort()) {
                          var chip = Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: FilterChip(
                              showCheckmark: false,
                              avatar: groupSelection[group] ?? false ? const CircleAvatar(backgroundColor: Colors.transparent, foregroundColor: Colors.black, child: Icon(Icons.check)) : null,
                              selectedColor: ColorSchemes.kingacolor,
                              label: Text(group),
                              selected: groupSelection[group] ?? false,
                              onSelected: (selected) {
                                setState(() {
                                  GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsListPermissionsChangeFilter);
                                  groupSelection[group] = !(groupSelection[group] ?? false);
                                });
                              },
                            ),
                          );
                          if (groupSelection[group] ?? false) {
                            selectedChips.add(chip);
                          } else {
                            unselectedChips.add(chip);
                          }
                        }
                        return selectedChips + unselectedChips;
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
                              IntrinsicWidth(
                                child: Container(
                                  decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: permitted ? ColorSchemes.kingacolor : ColorSchemes.errorColor, width: 0)), color: permitted ? ColorSchemes.kingacolor : ColorSchemes.errorColor),
                                  child: DropdownButtonFormField<bool>(
                                    style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                    decoration: InputDecoration (
                                        isDense: true,
                                        prefixIcon: Container(padding: const EdgeInsets.fromLTRB(4, 3, 2, 5), child: Icon(size: 24, permitted ? Icons.check : Icons.close, color: Colors.black)),
                                        prefixIconConstraints: const BoxConstraints(maxHeight: 30),
                                        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                        contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4)
                                    ),
                                    alignment: Alignment.center,
                                    value: permitted,
                                    items: const [
                                      DropdownMenuItem(value: true, child: Text(Strings.permitted)),
                                      DropdownMenuItem(value: false, child: Text(Strings.prohibited)),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsListPermissionsChangeFilter);
                                        permitted = value ?? permitted;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              FilterChip(
                                showCheckmark: false,
                                avatar: onlyAttendantStudents ? const CircleAvatar(backgroundColor: Colors.transparent, foregroundColor: Colors.black, child: Icon(Icons.check)) : null,
                                label: const Text(Strings.filterAttendant),
                                selected: onlyAttendantStudents,
                                selectedColor: ColorSchemes.kingacolor,
                                onSelected: (selected) {
                                  setState(() {
                                    GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsListPermissionsChangeFilter);
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
                  ],
                ),
              ),
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

                  return GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 10, crossAxisCount: 3),
                    children: list,
                  );
                } (),
              )
            ]),
          );
        },
    ));
  }
}