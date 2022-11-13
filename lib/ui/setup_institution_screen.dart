import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/ui/qr_scanner_dialog.dart';
import 'package:kinga/ui/show_institution_qr_code_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  TextEditingController _loginInstitutionIdInputController = TextEditingController();
  TextEditingController _loginInstitutionPasswordInputController = TextEditingController();

  late TabController _tabController;
  int _tabIndex = 0;
  List<Widget> _tabs = [];

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
    return Scaffold(
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
              Expanded(child: Container(), flex: 1,),
              Center(child: Text(textAlign: TextAlign.center, style: TextStyle(fontSize: 25), Strings.joinInstitution)),
              Expanded(child: Container(), flex: 1,),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _loginInstitutionIdInputController,
                decoration: InputDecoration(labelText: Strings.institutionId),
                validator: institutionIdValidator,
              ),
              TextFormField(
                obscureText: true,
                onFieldSubmitted: (value) => submitLoginForm(),
                controller: _loginInstitutionPasswordInputController,
                decoration: InputDecoration(labelText: Strings.password),
                validator: passwordValidator,
              ),
              Expanded(child: Container(), flex: 1),
              Text(Strings.alternative),
              Expanded(child: Container(), flex: 1),
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
              Expanded(child: Container(), flex: 2),
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
              Expanded(child: Container(), flex: 1,),
              Center(child: Text(textAlign: TextAlign.center, style: TextStyle(fontSize: 25), Strings.createInstitution)),
              Expanded(child: Container(), flex: 1,),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: createInstitutionNameInputController,
                decoration: const InputDecoration(labelText: Strings.institutionName),
                validator: institutionIdValidator,
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
      _institutionRepository.joinInstitution(_loginInstitutionIdInputController.text, _loginInstitutionPasswordInputController.text);
    }
  }

  void submitCreateInstitutionForm() async {
    if (_createInstitutionFormKey.currentState!.validate()) {
      String? institutionId = await _institutionRepository.createInstitution(createInstitutionNameInputController.text, _createInstitutionPassword);
      if (institutionId != null) {
        showDialog(context: context, builder: (context) => ShowInstitutionQrCodeScreen(institutionId, _createInstitutionPassword),)
            .then((value) => _institutionRepository.joinInstitution(institutionId, _createInstitutionPassword));
      } else {
        // TODO: error handling
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(Strings.errorUnexpected)));
      }
    }
  }

  String? institutionIdValidator(value) {
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

}
