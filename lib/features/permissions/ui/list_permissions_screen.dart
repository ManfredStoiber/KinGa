import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/features/permissions/domain/permission_service.dart';
import 'package:kinga/features/permissions/ui/create_permission_screen.dart';
import 'package:kinga/features/permissions/ui/show_permission_screen.dart';

class ListPermissionsScreen extends StatelessWidget {
  const ListPermissionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PermissionService permissionService = GetIt.I<PermissionService>();
    List<String> permissions = permissionService.getPermissions()..sort();
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.permission),
        actions: [
          IconButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreatePermissionScreen(),));
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: permissions.isEmpty ?
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(margin: const EdgeInsets.all(30), width: 200, child: Opacity(opacity: 0.7, child: Image.asset('assets/images/no_permissions.png'))),
          Text(Strings.noPermissionsYet, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
          Container(margin: const EdgeInsets.all(20), child: Text(Strings.noPermissionsYetDescription, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
        ],
      ) :
      ListView.separated(itemCount: permissions.length, itemBuilder: (context, permissionIndex) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowPermissionScreen(permissions.elementAt(permissionIndex)),));
          },
            trailing: const Icon(Icons.arrow_forward),
          title: Text(permissions.elementAt(permissionIndex))
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1,),),
    );
  }
}
