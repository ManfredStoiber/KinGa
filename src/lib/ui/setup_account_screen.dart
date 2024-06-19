import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/authentication_service.dart';

class SetupAccountScreen extends StatefulWidget {
  const SetupAccountScreen({Key? key}) : super(key: key);

  @override
  State<SetupAccountScreen> createState() => _SetupAccountScreenState();

}

class _SetupAccountScreenState extends State<SetupAccountScreen> with TickerProviderStateMixin {
  final _authenticationService = GetIt.I<AuthenticationService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 2,child: Container(),),
              const Center(child: Text(textAlign: TextAlign.center, style: TextStyle(fontSize: 25), Strings.greeting)),
              Expanded(child: Container(),),
              ElevatedButton(onPressed: () {
                _authenticationService.signIn().then((value) {
                  if (value == null) {
                    context.go('/');
                  } else {
                    // TODO: display error message
                  }
                });
              }, child: const Text(Strings.signIn)),
              Expanded(flex: 2,child: Container(),)
            ],
          )
        ),
    );
  }

}
