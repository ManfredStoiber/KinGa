import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/ui/qr_scanner_dialog.dart';
import 'package:kinga/ui/show_institution_qr_code_screen.dart';

class SetupInstitutionScreen extends StatefulWidget {
  const SetupInstitutionScreen({Key? key}) : super(key: key);

  @override
  State<SetupInstitutionScreen> createState() => _SetupInstitutionScreenState();

}

class _SetupInstitutionScreenState extends State<SetupInstitutionScreen> with TickerProviderStateMixin {

  late final InstitutionRepository _institutionRepository;

  final _createInstitutionFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  bool _alreadyRegistered = false;
  TextEditingController createInstitutionNameInputController = TextEditingController();
  TextEditingController registrationPasswordInputController = TextEditingController();
  TextEditingController registrationPasswordRepeatInputController = TextEditingController();
  String _createInstitutionPassword = "";

  final TextEditingController _loginInstitutionIdInputController = TextEditingController();
  final TextEditingController _loginInstitutionPasswordInputController = TextEditingController();

  late TabController _tabController;
  int _tabIndex = 0;
  List<Widget> _tabs = [];
  bool passwordVisible = false;

  @override
  void initState() {
    _tabs = [tab1(), ...tabsCreateInstitution()];
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
    _institutionRepository = GetIt.I<InstitutionRepository>();
    _createInstitutionPassword = generatePassword();
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
                        submitCreateInstitutionForm();
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
                ? tabsJoinInstitution()
                : tabsCreateInstitution()
          ])
        ),
    );
  }

  Widget tab1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(flex: 2,child: Container(),),
        const Center(child: Text(textAlign: TextAlign.center, style: TextStyle(fontSize: 25), Strings.notInInstitutionYet)),
        Expanded(child: Container(),),
        RadioListTile(
            title: const Text(Strings.createInstitution),
            value: false,
            groupValue: _alreadyRegistered,
            onChanged: (value) {
              setState(() {
                _alreadyRegistered = false;
                _tabs = [tab1(), ...tabsCreateInstitution()];
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
            title: const Text(Strings.joinInstitution),
            value: true,
            groupValue: _alreadyRegistered,
            onChanged: (value) {
              setState(() {
                _alreadyRegistered = true;
                _tabs = [tab1(), ...tabsJoinInstitution()];
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

  List<Widget> tabsJoinInstitution() {
    return [
      Container(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1,child: Container(),),
              const Center(child: Text(textAlign: TextAlign.center, style: TextStyle(fontSize: 25), Strings.joinInstitution)),
              Expanded(flex: 1,child: Container(),),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _loginInstitutionIdInputController,
                decoration: const InputDecoration(labelText: Strings.institutionId),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.errorIdEmpty;
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                obscureText: !passwordVisible,
                onFieldSubmitted: (value) => submitLoginForm(),
                controller: _loginInstitutionPasswordInputController,
                decoration: InputDecoration(
                  labelText: Strings.password,
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => togglePasswordVisibility(),
                  )
                ),
                validator: passwordValidator,
              ),
              Expanded(flex: 1, child: Container()),
              const Text(Strings.alternative),
              Expanded(flex: 1, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      String? data = await showDialog(context: context, builder: (context) => QrScannerDialog());
                      if (data != null) {
                        final code = json.decode(data);
                        String? institutionId = code[Keys.institutionId];
                        String? institutionPassword = code[Keys.institutionPassword];
                        if (institutionId != null && institutionPassword != null) {
                          _loginInstitutionIdInputController.text = institutionId;
                          _loginInstitutionPasswordInputController.text = institutionPassword;
                          submitLoginForm();
                        } else {
                          // TODO: error/retry message
                        }

                      }
                    },
                    child: Row(
                      children: [
                        Container(padding: const EdgeInsets.all(5), child: const Icon(Icons.qr_code_scanner)),
                        const Text(
                          Strings.scanQr
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> tabsCreateInstitution() {
    return [
      Container(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _createInstitutionFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1,child: Container(),),
              const Center(child: Text(textAlign: TextAlign.center, style: TextStyle(fontSize: 25), Strings.createInstitution)),
              Expanded(flex: 1,child: Container(),),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                controller: createInstitutionNameInputController,
                decoration: const InputDecoration(labelText: Strings.institutionName),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.errorInstitutionNameEmpty;
                  } else {
                    return null;
                  }
                },
              ),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    ];
  }

  void submitLoginForm() async {
    if (_loginFormKey.currentState!.validate()) {
      LoadingIndicatorDialog.show(context);
      _institutionRepository.joinInstitution(_loginInstitutionIdInputController.text, _loginInstitutionPasswordInputController.text).then((_) {
        Navigator.of(context).pop();
      },);
    }
  }

  void submitCreateInstitutionForm() async {
    if (_createInstitutionFormKey.currentState!.validate()) {
      LoadingIndicatorDialog.show(context);
      _institutionRepository.createInstitution(createInstitutionNameInputController.text, _createInstitutionPassword).then((institutionId) {
        Navigator.of(context).pop();
        if (institutionId != null) {
          showDialog(context: context, builder: (context) => ShowInstitutionQrCodeScreen(institutionId, _createInstitutionPassword),)
              .then((value) {
                LoadingIndicatorDialog.show(context);
                _institutionRepository.joinInstitution(institutionId, _createInstitutionPassword).then((value) => Navigator.of(context).pop());
              });
        } else {
          // TODO: error handling
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text(Strings.errorUnexpected)));
        }
      });
    }
  }

  String? passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return Strings.errorPasswordEmpty;
    }
    return null;
  }

  String generatePassword() {
    const length = 14;
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';

    String chars = "";
    chars += letterLowerCase;
    chars += letterUpperCase;
    chars += number;
    chars += special;

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars [indexRandom];
    }).join('');
  }

  void togglePasswordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }
}
