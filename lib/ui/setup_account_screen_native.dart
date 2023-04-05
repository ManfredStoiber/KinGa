
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/authentication_service.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/ui/widgets/virtual_keyboard/virtual_keyboard_multi_language.dart';

class SetupAccountScreenNative extends StatefulWidget {
  const SetupAccountScreenNative({Key? key}) : super(key: key);

  @override
  State<SetupAccountScreenNative> createState() => _SetupAccountScreenNativeState();

}

class _SetupAccountScreenNativeState extends State<SetupAccountScreenNative> with TickerProviderStateMixin {
  final _authenticationService = GetIt.I<AuthenticationService>();
  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController loginEmailInputController = TextEditingController();
  TextEditingController loginPasswordInputController = TextEditingController();
  bool passwordVisible = false;

  // keyboard
  final emailFocusNode = FocusNode();
  TextSelection emailTextSelection = TextSelection.collapsed(offset: 0);
  final passwordFocusNode = FocusNode();
  TextSelection passwordTextSelection = TextSelection.collapsed(offset: 0);
  String keyboardFocus = "";
  bool shiftEnabled = false;


  late TabController _tabController;
  int _tabIndex = 0;
  List<Widget> _tabs = [];

  @override
  void initState() {
    _tabs = [...tabsAlreadyRegistered()];
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });

    emailFocusNode.addListener(() => setState(() {
      if (emailFocusNode.hasFocus) {
        keyboardFocus = "email";
      }
    }));
    passwordFocusNode.addListener(() => setState(() {
      if (passwordFocusNode.hasFocus) {
        keyboardFocus = "password";
      }
    }));

    loginEmailInputController.addListener(() {
      if (loginEmailInputController.selection.isValid) {
        emailTextSelection = loginEmailInputController.selection;
      }
    });

    loginPasswordInputController.addListener(() {
      if (loginPasswordInputController.selection.isValid) {
        passwordTextSelection = loginPasswordInputController.selection;
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
          child: BottomAppBar(
            color: ColorSchemes.backgroundColor,
            child:
              IntrinsicHeight(child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  Container(
                    margin: EdgeInsets.all(5.0),
                    child: TextButton(
                        onPressed: () async {
                          if (_tabIndex == 0) {
                            submitLoginForm();
                          }
                        },
                        child: Text((){
                          if (_tabIndex == 0) {
                            return Strings.signIn;
                          } else {
                            return Strings.next;
                          }
                        }())
                    ),
                  ),
                ],),
                Visibility(
                  visible: keyboardFocus == 'email' || keyboardFocus == 'password',
                  child: VirtualKeyboard(height: 150.0, type: VirtualKeyboardType.Alphanumeric, defaultLayouts: [VirtualKeyboardDefaultLayouts.GermanWithSpecialCharacters], onKeyPress: (VirtualKeyboardKey key) {
                    bool keepFocus = true;
                    if (key.keyType == VirtualKeyboardKeyType.String) {
                      if (keyboardFocus == 'email') {
                        var selection = TextSelection.collapsed(offset: emailTextSelection.start + 1);
                        var text = loginEmailInputController.text;
                        loginEmailInputController.text = text.substring(0, emailTextSelection.start) + (shiftEnabled ? key.capsText ?? "" : key.text ?? "") + text.substring(emailTextSelection.end);
                        // set cursor to correct position
                        loginEmailInputController.value = TextEditingValue(
                            text: loginEmailInputController.text,
                            selection: selection
                        );
                      } else if (keyboardFocus == 'password') {
                        var selection = TextSelection.collapsed(offset: passwordTextSelection.start + 1);
                        var text = loginPasswordInputController.text;
                        loginPasswordInputController.text = text.substring(0, passwordTextSelection.start) + (shiftEnabled ? key.capsText ?? "" : key.text ?? "") + text.substring(passwordTextSelection.end);
                        // set cursor to correct position
                        loginPasswordInputController.value = TextEditingValue(
                            text: loginPasswordInputController.text,
                            selection: selection
                        );
                      }
                    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                      switch (key.action) {
                        case VirtualKeyboardKeyAction.Backspace:
                          if (keyboardFocus == 'email') {
                            if (loginEmailInputController.text.isEmpty) return;
                            var selection = emailTextSelection;
                            var text = loginEmailInputController.text;
                            if (emailTextSelection.isCollapsed && emailTextSelection.start != 0) {
                              loginEmailInputController.text = text.substring(0, emailTextSelection.start - 1) + text.substring(emailTextSelection.start);
                              selection = TextSelection.collapsed(offset: emailTextSelection.start - 1);
                            } else if (!emailTextSelection.isCollapsed) {
                              loginEmailInputController.text = text.substring(0, emailTextSelection.start) + text.substring(emailTextSelection.end);
                              selection = TextSelection.collapsed(offset: emailTextSelection.start);
                            }
                            // set cursor to correct position
                            loginEmailInputController.value = TextEditingValue(
                                text: loginEmailInputController.text,
                                selection: selection
                            );
                          } else if (keyboardFocus == 'password') {
                            if (loginPasswordInputController.text.isEmpty) return;
                            var selection = passwordTextSelection;
                            var text = loginPasswordInputController.text;
                            if (passwordTextSelection.isCollapsed && passwordTextSelection.start != 0) {
                              loginPasswordInputController.text = text.substring(0, passwordTextSelection.start - 1) + text.substring(passwordTextSelection.start);
                              selection = TextSelection.collapsed(offset: passwordTextSelection.start - 1);
                            } else if (!passwordTextSelection.isCollapsed) {
                              loginPasswordInputController.text = text.substring(0, passwordTextSelection.start) + text.substring(passwordTextSelection.end);
                              selection = TextSelection.collapsed(offset: passwordTextSelection.start);
                            }
                            // set cursor to correct position
                            loginPasswordInputController.value = TextEditingValue(
                                text: loginPasswordInputController.text,
                                selection: selection
                            );
                          }
                          break;
                        case VirtualKeyboardKeyAction.Return:
                          if (keyboardFocus == 'email') {
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

                    if (keepFocus && keyboardFocus == 'email') {
                      emailFocusNode.requestFocus();
                    }
                    if (keepFocus && keyboardFocus == 'password') {
                      passwordFocusNode.requestFocus();
                    }
                    setState(() { });
                  },),
                )
              ])),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          ...tabsAlreadyRegistered()
        ])
    );
  }

  List<Widget> tabsAlreadyRegistered() {
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
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Expanded(flex: 2, child: Container(),),
                  Center(child: Text(textAlign: TextAlign.center, style: TextStyle(fontSize: 25), Strings.greeting)),
                  //Expanded(flex: 1, child: Container(),),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: loginEmailInputController,
                    decoration: InputDecoration(labelText: Strings.email),
                    validator: emailValidator,
                    focusNode: emailFocusNode,
                    inputFormatters: [FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))],
                    onTap: () {
                      setState(() {
                        keyboardFocus = 'email';
                      });
                    },
                  ),
                  TextFormField(
                    obscureText: !passwordVisible,
                    onFieldSubmitted: (value) => submitLoginForm(),
                    controller: loginPasswordInputController,
                    decoration: InputDecoration(labelText: Strings.password, suffixIcon: IconButton(
                      icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    )),
                    validator: passwordValidator,
                    focusNode: passwordFocusNode,
                    inputFormatters: [FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))],
                    onTap: () {
                      setState(() {
                        keyboardFocus = 'password';
                      });
                    },
                  ),
                  //Expanded(flex: 2,child: Container(),),

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
      _authenticationService.signInWithEmailAndPassword(loginEmailInputController.text, loginPasswordInputController.text).then((error) {
        Navigator.of(context).pop();
        if (error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error)));
        }
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
