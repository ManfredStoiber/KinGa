import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/features/permissions/domain/permission_service.dart';

class CreatePermissions extends StatefulWidget {
  CreatePermissions(this.permissions, {Key? key}) : super(key: key);
  
  Set<String> permissions;

  @override
  State<CreatePermissions> createState() => _CreatePermissionsState();
}

class _CreatePermissionsState extends State<CreatePermissions> with AutomaticKeepAliveClientMixin {
  PermissionService permissionService = GetIt.I<PermissionService>();
  List<String> allPermissions = [];
  Map<String, bool> currentPermissions = {};

  @override
  void initState() {
    super.initState();
    allPermissions = permissionService.getPermissions()..sort();

    for (var permission in allPermissions) {
      currentPermissions[permission] = false;
    }
    for (var permission in widget.permissions) {
      currentPermissions[permission] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return allPermissions.isNotEmpty ?
    Column(
      children: [
        Card(
          margin: const EdgeInsets.all(10),
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, permissionIndex) {
                return ListTile(
                  title: Text(allPermissions.elementAt(permissionIndex)),
                  onTap: () {
                    setState(() {
                      _togglePermission(currentPermissions[allPermissions.elementAt(permissionIndex)] ?? false, permissionIndex);
                    });
                  },
                  trailing: Switch(
                    value: currentPermissions[allPermissions.elementAt(permissionIndex)] ?? false,
                    onChanged: (bool value) {
                      setState(() {
                        _togglePermission(!value, permissionIndex);
                      });
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1,),
              itemCount: allPermissions.length
          ),
        ),
        const Spacer()
      ],
    ) :
    Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(margin: const EdgeInsets.all(30), width: 200, child: Opacity(opacity: 0.7, child: Image.asset('assets/images/no_permissions.png'))),
        Text(Strings.noPermissionsYet, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
        Container(margin: const EdgeInsets.all(20), child: Text(Strings.noPermissionsCreateStudent, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
      ],
    );
  }

  void _togglePermission(bool value, int index) {
    String permission = allPermissions.elementAt(index);
    if (value) {
      widget.permissions.remove(permission);
    } else {
      widget.permissions.add(permission);
    }
    currentPermissions[allPermissions.elementAt(index)] = !(currentPermissions[allPermissions.elementAt(index)] ?? false);
  }

  @override
  bool get wantKeepAlive => true;
}
