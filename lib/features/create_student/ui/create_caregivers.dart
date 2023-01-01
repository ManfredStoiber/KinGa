import 'package:flutter/material.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';

class CreateCaregivers extends StatefulWidget {
  CreateCaregivers(this.caregivers, this.optionalFields, this.formKeyTab, {Key? key}) : super(key: key) {
    for (var caregiver in caregivers) {
      for (var phoneNumber in caregiver['phoneNumbers']) {
        if (!phoneLabels.contains(phoneNumber[0]) && phoneNumber[0].toString().isNotEmpty) {
          phoneLabels.add(phoneNumber[0]);
        }
      }
    }
  }

  final Set<String> optionalFields;
  final GlobalKey formKeyTab;
  final GlobalKey<FormState> phoneLabelKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> caregivers;
  List<String> phoneLabels = ['Mobil', 'Privat', 'Arbeit'];

  @override
  State<CreateCaregivers> createState() => _CreateCaregiversState();
}

class _CreateCaregiversState extends State<CreateCaregivers> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {

    return Form(
      key: widget.formKeyTab,
      child: ListView.builder(itemCount: widget.caregivers.length + 1, itemBuilder: (context, i) {
        if (i < widget.caregivers.length) {
          return Card(
            key: UniqueKey(),
            margin: const EdgeInsets.all(10),
            child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            '${Strings.contact} ${i + 1}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (widget.caregivers.length > 1) {
                                FocusScope.of(context).unfocus();
                                widget.caregivers.removeAt(i);
                              } else {
                                showDialog(context: context, builder: (context) => AlertDialog(
                                  title: const Text(Strings.requiredCaregiver),
                                  actions: [
                                    TextButton(onPressed: () {
                                      Navigator.of(context).pop();
                                    }, child: const Text(Strings.okay)),
                                  ],
                                ));
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: ColorSchemes.errorColor,
                          )
                      )
                    ],
                  ),
                  buildTextField(Strings.label, 'label', widget.caregivers.elementAt(i)),
                  buildTextField(Strings.firstname, 'firstname', widget.caregivers.elementAt(i)),
                  buildTextField(Strings.lastname, 'lastname', widget.caregivers.elementAt(i)),
                  for (var phoneNumber in widget.caregivers[i]['phoneNumbers'])
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: DropdownButtonFormField<String>(
                              value: phoneNumber[0].toString().isNotEmpty ? phoneNumber[0] : null,
                              hint: const Text(Strings.phoneLabel),
                              items: [
                                for (var label in widget.phoneLabels)
                                  DropdownMenuItem(
                                      value: label, child: Text(label)),
                                DropdownMenuItem(
                                    value: Strings.custom,
                                    child: Text(Strings.custom, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))
                                )
                              ],
                              onChanged:(String? value) {
                                setState(() {
                                  String? previousLabel = phoneNumber[0];
                                  phoneNumber[0] = value!;

                                  if (value == Strings.custom) {
                                    showDialog(context: context, builder: (context) {
                                      TextEditingController phoneLabelController = TextEditingController();

                                      return AlertDialog(
                                        title: const Text(Strings.newLabelnameInfo),
                                        actions: [
                                          TextButton(onPressed: () {
                                            setState(() {
                                              phoneNumber[0] = previousLabel;
                                            });
                                            Navigator.of(context).pop();
                                          }, child: const Text(Strings.cancel)),
                                          TextButton(onPressed: () {
                                            if (widget.phoneLabelKey.currentState?.validate() ?? false) {
                                              Navigator.of(context).pop(phoneLabelController.text);
                                            }
                                          }, child: const Text(Strings.confirm))
                                        ],
                                        content: Form(
                                          key: widget.phoneLabelKey,
                                          child: TextFormField(
                                            controller: phoneLabelController,
                                            textCapitalization: TextCapitalization.sentences,
                                            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: Strings.phoneLabel),
                                            validator: (value) {
                                              if (value == null || value.trim().isEmpty) {
                                                return '${Strings.phoneLabel} ${Strings.requiredFieldMessage}';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      );},
                                    ).then((result) {
                                      if (result != null) {
                                        setState(() {
                                          String value = result.trim();
                                          phoneNumber[0] = value;
                                          widget.phoneLabels.add(value);
                                        });
                                      }
                                    });
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return '${Strings.phoneLabel} ${Strings.requiredFieldMessage}';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              initialValue: phoneNumber[1],
                              textInputAction: TextInputAction.next,
                              onChanged: (String? value) {
                                phoneNumber[1] = value?.trim();
                              },
                              scrollPadding: const EdgeInsets.all(40),
                              decoration:
                              const InputDecoration(border: OutlineInputBorder(), labelText: Strings.phoneNumber),
                              validator: (value) {
                                RegExp phoneNumber = RegExp(r"^[\+]?[0-9]+$"); // TODO: fix regex
                                if (value == null || value.trim().isEmpty) {
                                  return '${Strings.phoneNumber} ${Strings.requiredFieldMessage}';
                                } else if (!phoneNumber.hasMatch(value)){
                                  Strings.incorrectPhoneNumberFormat;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (widget.caregivers[i]['phoneNumbers'].length > 1) {
                                  FocusScope.of(context).unfocus();
                                  widget.caregivers[i]['phoneNumbers'].remove(phoneNumber);
                                } else {
                                  showDialog(context: context, builder: (context) => AlertDialog(
                                    title: const Text(Strings.requiredPhoneNumber),
                                    actions: [
                                      TextButton(onPressed: () {
                                        Navigator.of(context).pop();
                                      }, child: const Text(Strings.okay)),
                                    ],
                                  ));
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: ColorSchemes.errorColor,
                            )
                        )
                      ],
                    ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.caregivers[i]['phoneNumbers'].add(['', '']);
                      });
                    },
                    child: const Text(Strings.addPhoneNumber),),
                  buildTextField(Strings.email, 'email', widget.caregivers.elementAt(i)),
                ]
            ),
          );
        } else {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(15),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    widget.caregivers.add({'phoneNumbers': [['', '']]});
                  });
                },
              ),
            ),
          );
        }
      })
    );
  }

  Widget buildTextField(String label, String? property, Map<String, dynamic> caregiver) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        initialValue: caregiver[property],
        textInputAction: TextInputAction.next,
        onChanged: (String? value) {
          if (property != null) {
            caregiver[property] = value?.trim();
          }
        },
        scrollPadding: const EdgeInsets.all(40),
        decoration:
        InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            hintText: label == Strings.label ? Strings.caregiverLabelHint : null,
            floatingLabelBehavior: label == Strings.label ? FloatingLabelBehavior.always : null
        ),
        validator: (value) {
          RegExp email = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

          if ((value == null || value.trim().isEmpty) && !widget.optionalFields.contains(property)) {
            return '$label ${Strings.requiredFieldMessage}';
          } else if (value != null && value != '' && label == Strings.email && !email.hasMatch(value)) {
            return Strings.incorrectEmailFormat;
          } else {
            return null;
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
