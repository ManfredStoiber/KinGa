import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/authentication_service.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';

class SetupAccountScreen extends StatefulWidget {
  const SetupAccountScreen({Key? key}) : super(key: key);

  @override
  State<SetupAccountScreen> createState() => _SetupAccountScreenState();

}

class _SetupAccountScreenState extends State<SetupAccountScreen> with TickerProviderStateMixin {
  final _authenticationService = GetIt.I<AuthenticationService>();
  final _registerFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  bool _alreadyRegistered = false;
  TextEditingController registrationEmailInputController = TextEditingController();
  TextEditingController registrationPasswordInputController = TextEditingController();
  TextEditingController registrationPasswordRepeatInputController = TextEditingController();

  TextEditingController loginEmailInputController = TextEditingController();
  TextEditingController loginPasswordInputController = TextEditingController();

  late TabController _tabController;
  int _tabIndex = 0;
  List<Widget> _tabs = [];
  bool passwordVisible = false;
  bool passwordRepeatVisible = false;

  @override
  void initState() {
    _tabs = [tab1(), ...tabsNotRegisteredYet()];
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_tabIndex > 0) {
          _tabController.animateTo(_tabIndex -1);
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
            bottomNavigationBar: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: _tabIndex > 0,
                  child: TextButton(
                    onPressed: () {
                      if (_tabIndex > 0) {
                        _tabController.animateTo(_tabIndex -1);
                      }
                    },
                    child: const Text(Strings.back),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      if (_tabIndex == 0) {
                        _tabController.animateTo(_tabIndex +1);
                      } else if (_tabIndex == 1) {
                        if (_alreadyRegistered) {
                          submitLoginForm();
                        } else {
                          submitRegistrationForm();
                        }
                      }
                    },
                    child: Text((){
                      if (_tabIndex == 1 && _alreadyRegistered) {
                        return Strings.signIn;
                      } else if (_tabIndex == 1 && !_alreadyRegistered) {
                        return Strings.signUp;
                      } else {
                        return Strings.next;
                      }
                    }())
                )
              ],
            ),
            body: TabBarView(controller: _tabController, children: [
              tab1(),
              ..._alreadyRegistered
                  ? tabsAlreadyRegistered()
                  : tabsNotRegisteredYet()
            ])
          ),
      ),
    );
  }

  Widget tab1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(flex: 2,child: Container(),),
        const Center(child: Text(textAlign: TextAlign.center, style: TextStyle(fontSize: 25), Strings.greeting)),
        Expanded(child: Container(),),
        RadioListTile(
            title: const Text(Strings.notRegistered),
            value: false,
            groupValue: _alreadyRegistered,
            onChanged: (value) {
              setState(() {
                _alreadyRegistered = false;
                _tabs = [tab1(), ...tabsNotRegisteredYet()];
                _tabController.dispose();
                _tabController = TabController(length: _tabs.length, vsync: this);
                _tabController.addListener(() {
                  setState(() {
                    _tabIndex = _tabController.index;
                  });
                });
              });
            }),
        RadioListTile(
            title: const Text(Strings.alreadyRegistered),
            value: true,
            groupValue: _alreadyRegistered,
            onChanged: (value) {
              setState(() {
                _alreadyRegistered = true;
                _tabs = [tab1(), ...tabsAlreadyRegistered()];
                _tabController.dispose();
                _tabController = TabController(length: _tabs.length, vsync: this);
                _tabController.addListener(() {
                  setState(() {
                    _tabIndex = _tabController.index;
                  });
                });
              });
            }),
        Expanded(flex: 2,child: Container(),)
      ],
    );
  }

  List<Widget> tabsAlreadyRegistered() {
    bool passwordObscured = true;

    return [
      Container(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: loginEmailInputController,
                decoration: const InputDecoration(labelText: Strings.email),
                validator: emailValidator,
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))],
              ),
              TextFormField(
                obscureText: !passwordVisible,
                onFieldSubmitted: (value) => submitLoginForm(),
                controller: loginPasswordInputController,
                decoration: InputDecoration(
                  labelText: Strings.password,
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() {
                      passwordVisible = !passwordVisible;
                    }),
                  )
                ),
                validator: passwordValidator,
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> tabsNotRegisteredYet() {
    return [
      Container(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _registerFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: registrationEmailInputController,
                decoration: const InputDecoration(labelText: Strings.email),
                validator: emailValidator,
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))],
              ),
              TextFormField(
                obscureText: !passwordVisible,
                textInputAction: TextInputAction.next,
                controller: registrationPasswordInputController,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                  labelText: Strings.password,
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() {
                      passwordVisible = !passwordVisible;
                    }),
                  )
                ),
                validator: passwordValidator,
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))],
              ),
              TextFormField(
                obscureText: !passwordRepeatVisible,
                controller: registrationPasswordRepeatInputController,
                decoration: InputDecoration(
                  labelText: Strings.passwordRepeat,
                  suffixIcon: IconButton(
                    icon: Icon(passwordRepeatVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() {
                      passwordRepeatVisible = !passwordRepeatVisible;
                    }),
                  )
                ),
                onFieldSubmitted: (_) => submitRegistrationForm(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.errorRepeatPasswordEmpty;
                  } else if (value != registrationPasswordInputController.text) {
                    return Strings.errorRepeatPasswordNotEqual;
                  }
                  return null;
                },
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  void submitLoginForm() async {
    if (_loginFormKey.currentState!.validate()) {
      LoadingIndicatorDialog.show(context, Strings.loadLogin);
      _authenticationService.signInWithEmailAndPassword(loginEmailInputController.text, loginPasswordInputController.text).then((error) {
        if (error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error)));
        }
        Navigator.of(context).pop();
      });
    }
  }

  void submitRegistrationForm() async {
    if (_registerFormKey.currentState!.validate()) {
      LoadingIndicatorDialog.show(context, Strings.loadCreateUser);
      await _authenticationService.createUserWithEmailAndPassword(registrationEmailInputController.text, registrationPasswordInputController.text).then((error) {
        if (error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error)));
        }
        Navigator.of(context).pop();
      });
    }
  }

  String? emailValidator(value) {
    if (value == null || value.isEmpty) {
      return Strings.errorEmailEmpty;
    }
    return null;
  }

  String? passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return Strings.errorPasswordEmpty;
    }
    return null;
  }

}
