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
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/ui/widgets/virtual_keyboard/virtual_keyboard_multi_language.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class SetupInstitutionScreenNative extends StatefulWidget {
  const SetupInstitutionScreenNative({Key? key}) : super(key: key);

  @override
  State<SetupInstitutionScreenNative> createState() => _SetupInstitutionScreenNativeState();

}

class _SetupInstitutionScreenNativeState extends State<SetupInstitutionScreenNative> with TickerProviderStateMixin {

  late final InstitutionRepository _institutionRepository;

  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController _loginInstitutionIdInputController = TextEditingController();
  TextEditingController _loginInstitutionPasswordInputController = TextEditingController();
  bool passwordVisible = false;

  final institutionIdFocusNode = FocusNode();
  TextSelection institutionIdTextSelection = TextSelection.collapsed(offset: 0);
  final passwordFocusNode = FocusNode();
  TextSelection passwordTextSelection = TextSelection.collapsed(offset: 0);
  String keyboardFocus = "";
  bool shiftEnabled = false;

  late TabController _tabController;
  int _tabIndex = 0;
  List<Widget> _tabs = [];

  void debug() async {
    var response = await http.get(Uri.https("www.google.de"));

    if (response.statusCode == 200) {
      debugPrint("Successful!");
      return;
    } else {
      debugPrint("Failed!");
    }
  }

  @override
  void initState() {

  debug();

    _tabs = tabsJoinInstitution();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
    _institutionRepository = GetIt.I<InstitutionRepository>();

    institutionIdFocusNode.addListener(() => setState(() {
      if (institutionIdFocusNode.hasFocus) {
        keyboardFocus = "institutionId";
      }
    }));
    passwordFocusNode.addListener(() => setState(() {
      if (passwordFocusNode.hasFocus) {
        keyboardFocus = "password";
      }
    }));

    _loginInstitutionIdInputController.addListener(() {
      if (_loginInstitutionIdInputController.selection.isValid) {
        institutionIdTextSelection = _loginInstitutionIdInputController.selection;
      }
    });

    _loginInstitutionPasswordInputController.addListener(() {
      if (_loginInstitutionPasswordInputController.selection.isValid) {
        passwordTextSelection = _loginInstitutionPasswordInputController.selection;
      }
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
    return Scaffold(
        bottomNavigationBar: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() {
            keyboardFocus = '';
          }),
          child: BottomAppBar(child: IntrinsicHeight(
            child: Container(
              color: ColorSchemes.backgroundColor,
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    margin: EdgeInsets.all(5.0),
                    child: TextButton(
                        onPressed: () async {
                          submitLoginForm();
                        },
                        child: Text(Strings.signIn)
                    ),
                  )
                ],),
                Visibility(
                  visible: keyboardFocus == 'institutionId' || keyboardFocus == 'password',
                  child: VirtualKeyboard(height: 150.0, type: VirtualKeyboardType.Alphanumeric, defaultLayouts: [VirtualKeyboardDefaultLayouts.GermanWithSpecialCharacters], onKeyPress: (VirtualKeyboardKey key) {
                    bool keepFocus = true;
                    if (key.keyType == VirtualKeyboardKeyType.String) {
                      if (keyboardFocus == 'institutionId') {
                        var selection = TextSelection.collapsed(offset: institutionIdTextSelection.start + 1);
                        var text = _loginInstitutionIdInputController.text;
                        _loginInstitutionIdInputController.text = text.substring(0, institutionIdTextSelection.start) + (shiftEnabled ? key.capsText ?? "" : key.text ?? "") + text.substring(institutionIdTextSelection.end);
                        // set cursor to correct position
                        _loginInstitutionIdInputController.value = TextEditingValue(
                            text: _loginInstitutionIdInputController.text,
                            selection: selection
                        );
                      } else if (keyboardFocus == 'password') {
                        var selection = TextSelection.collapsed(offset: passwordTextSelection.start + 1);
                        var text = _loginInstitutionPasswordInputController.text;
                        _loginInstitutionPasswordInputController.text = text.substring(0, passwordTextSelection.start) + (shiftEnabled ? key.capsText ?? "" : key.text ?? "") + text.substring(passwordTextSelection.end);
                        // set cursor to correct position
                        _loginInstitutionPasswordInputController.value = TextEditingValue(
                            text: _loginInstitutionPasswordInputController.text,
                            selection: selection
                        );
                      }
                    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                      switch (key.action) {
                        case VirtualKeyboardKeyAction.Backspace:
                          if (keyboardFocus == 'institutionId') {
                            if (_loginInstitutionIdInputController.text.isEmpty) return;
                            var selection = institutionIdTextSelection;
                            var text = _loginInstitutionIdInputController.text;
                            if (institutionIdTextSelection.isCollapsed && institutionIdTextSelection.start != 0) {
                              _loginInstitutionIdInputController.text = text.substring(0, institutionIdTextSelection.start - 1) + text.substring(institutionIdTextSelection.start);
                              selection = TextSelection.collapsed(offset: institutionIdTextSelection.start - 1);
                            } else if (!institutionIdTextSelection.isCollapsed) {
                              _loginInstitutionIdInputController.text = text.substring(0, institutionIdTextSelection.start) + text.substring(institutionIdTextSelection.end);
                              selection = TextSelection.collapsed(offset: institutionIdTextSelection.start);
                            }
                            // set cursor to correct position
                            _loginInstitutionIdInputController.value = TextEditingValue(
                                text: _loginInstitutionIdInputController.text,
                                selection: selection
                            );
                          } else if (keyboardFocus == 'password') {
                            if (_loginInstitutionPasswordInputController.text.isEmpty) return;
                            var selection = passwordTextSelection;
                            var text = _loginInstitutionPasswordInputController.text;
                            if (passwordTextSelection.isCollapsed && passwordTextSelection.start != 0) {
                              _loginInstitutionPasswordInputController.text = text.substring(0, passwordTextSelection.start - 1) + text.substring(passwordTextSelection.start);
                              selection = TextSelection.collapsed(offset: passwordTextSelection.start - 1);
                            } else if (!passwordTextSelection.isCollapsed) {
                              _loginInstitutionPasswordInputController.text = text.substring(0, passwordTextSelection.start) + text.substring(passwordTextSelection.end);
                              selection = TextSelection.collapsed(offset: passwordTextSelection.start);
                            }
                            // set cursor to correct position
                            _loginInstitutionPasswordInputController.value = TextEditingValue(
                                text: _loginInstitutionPasswordInputController.text,
                                selection: selection
                            );
                          }
                          break;
                        case VirtualKeyboardKeyAction.Return:
                          if (keyboardFocus == 'institutionId') {
                            keyboardFocus = 'password'; // jump to password input
                          } else if (keyboardFocus == 'password') {
                            keyboardFocus = ''; // remove focus
                            keepFocus = false;
                            submitLoginForm();
                          }
                          break;
                        case VirtualKeyboardKeyAction.Shift:
                          shiftEnabled = !shiftEnabled;
                          break;
                        default:
                      }
                    }

                    if (keepFocus && keyboardFocus == 'institutionId') {
                      institutionIdFocusNode.requestFocus();
                    }
                    if (keepFocus && keyboardFocus == 'password') {
                      passwordFocusNode.requestFocus();
                    }
                    setState(() { });
                  },),
                )
                ]),
            ),
          ),

          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          ...tabsJoinInstitution()
        ])
      );
  }

  List<Widget> tabsJoinInstitution() {
    return [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => setState(() {
          keyboardFocus = '';
        }),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _loginFormKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(child: Text(textAlign: TextAlign.center, style: TextStyle(fontSize: 25), Strings.joinInstitution)),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _loginInstitutionIdInputController,
                    decoration: InputDecoration(labelText: Strings.institutionId),
                    focusNode: institutionIdFocusNode,
                    validator: institutionIdValidator,
                    onTap: () {
                      setState(() {
                        keyboardFocus = 'institutionId';
                      });
                    },
                  ),
                  TextFormField(
                    obscureText: !passwordVisible,
                    onFieldSubmitted: (value) => submitLoginForm(),
                    controller: _loginInstitutionPasswordInputController,
                    decoration: InputDecoration(labelText: Strings.password, suffixIcon: IconButton(
                      icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    )),
                    focusNode: passwordFocusNode,
                    validator: passwordValidator,
                    onTap: () {
                      setState(() {
                        keyboardFocus = 'password';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  void submitLoginForm() async {
    if (_loginFormKey.currentState!.validate()) {
      LoadingIndicatorDialog.show(context);
      _institutionRepository.joinInstitution(_loginInstitutionIdInputController.text, _loginInstitutionPasswordInputController.text).then((error) {
        Navigator.of(context).pop();
        if (error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error)));
        }
      });
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
