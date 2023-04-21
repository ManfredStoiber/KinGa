import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/routes.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/features/permissions/domain/permission_service.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ListPermissionsScreen extends StatelessWidget {

  const ListPermissionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PermissionService permissionService = GetIt.I<PermissionService>();
    List<String> permissions = permissionService.getPermissions()..sort();
    return WillPopScope(
      onWillPop: () async {
        var tmp = Navigator.of(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.permission),
          actions: [
            IconButton(onPressed: () {
            context.goNamed(Routes.createPermission);
            }, icon: const Icon(Icons.add))
          ],
        ),
        body: permissions.isEmpty ?
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(margin: const EdgeInsets.all(30), width: 200, child: SimpleShadow(child: Opacity(opacity: 0.4, child: Image.asset('assets/images/no_permissions.png')))),
            Text(Strings.noPermissionsYet, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
            Container(margin: const EdgeInsets.all(20), child: Text(Strings.noPermissionsYetDescription, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
          ],
        ) :
        ListView.separated(itemCount: permissions.length, itemBuilder: (context, permissionIndex) {
          return ListTile(
            onTap: () {
              GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsListPermissions);
              //context.push('${Routes.permission}/${permissions.elementAt(permissionIndex)}');
              context.goNamed(Routes.showPermission, pathParameters: {'permission': permissions.elementAt(permissionIndex)});
            },
              trailing: const Icon(Icons.arrow_forward),
            title: Text(permissions.elementAt(permissionIndex))
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1,),),
      ),
    );
  }
}
