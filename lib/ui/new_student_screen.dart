import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';

import 'attendance_screen.dart';

class NewStudentScreen extends StatefulWidget {
  const NewStudentScreen({Key? key}) : super(key: key);

  @override
  State<NewStudentScreen> createState() => _NewStudentScreenState();
}

class _NewStudentScreenState extends State<NewStudentScreen>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  late TabController _tabController;

  Map<String, dynamic> student = {};

  Uint8List _profileImage = Uint8List(0);

  List<Caregiver> caregivers = [
    Caregiver("", "", "", {'Nummer1': '12345', 'Nummer2': '23456'}, ""),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: BottomAppBar(child: Container(height: 50,),),
      appBar: AppBar(
        title: Text(Strings.createNewStudent),
        bottom: TabBar(controller: _tabController, isScrollable: true, tabs: [
          Tab(text: Strings.infoGeneral),
          Tab(text: Strings.infoPickup),
          Tab(text: Strings.infoHealth),
          Tab(text: Strings.permission),
        ]),
      ),
      body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            buildTab1(context),
            buildTab2(),
            Text('Page 3'),
            Text('Page 4'),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Wrap(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Visibility(
                visible: _tabIndex != 0,
                child: FloatingActionButton(
                    heroTag: 'fab2',
                    onPressed: () {
                      _tabController.animateTo(_tabIndex - 1);
                    },
                    child: Icon(Icons
                        .arrow_back) //(if (_tabIndex == 0) {Text('Weiter') : Text('Fertig')})
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 15),
              child: FloatingActionButton(
                  heroTag: 'fab1',
                  onPressed: () {
                    if (_tabIndex == 3) {
                      student['caregivers'] = caregivers;
                      BlocProvider.of<StudentsCubit>(context).createStudent(student, _profileImage);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const AttendanceScreen()));
                    } else {
                      _tabController.animateTo(_tabIndex + 1);
                    }
                  },
                  child: (() {
                    if (_tabIndex == 3) {
                      return Icon(Icons.check);
                    } else {
                      return Icon(Icons.arrow_forward);
                    }
                  }()) //(if (_tabIndex == 0) {Text('Weiter') : Text('Fertig')})
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Form buildTab2() {
    return Form(
      child: ListView(
          children: caregivers
              .asMap()
              .entries
              .map((caregiver) =>
          Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Kontakt ${caregiver.key + 1}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(child: Container()),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                caregivers
                                    .removeAt(caregiver.key);
                              });
                            },
                            icon: Icon(
                              Icons.delete_forever,
                              color: ColorSchemes.errorColor,
                            ))
                      ],
                    )
                  ],
                ) as Widget,
                buildTextField('Bezeichnung', null),
                buildTextField('Vorname', null),
                buildTextField('Nachname', null)
              ] +
                  caregiver.value.phoneNumbers.entries
                      .map((phoneNumber) =>
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: buildTextField(
                                  phoneNumber.key, null)),
                          Expanded(
                              child: buildTextField(
                                  phoneNumber.value, null)),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.close,
                                color: ColorSchemes.errorColor,
                              ))
                        ],
                      ))
                      .toList() +
                  [
                    MaterialButton(onPressed: () {

                    },
                      child: Text('Nummer hinzufügen'),),
                    buildTextField('E-Mail', null),
                    buildTextField('Postleitzahl', null),
                  ],
            ),
          ) as Widget)
              .toList() +
              [
                Center(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          caregivers.add(Caregiver("", "", "", {}, ""));
                        });
                      },
                    ),
                  ),
                )
              ]),
    );
  }

  ListView buildTab1(BuildContext context) {
    return ListView(children: [
      Wrap(children: [
        Card(
          margin: EdgeInsets.all(10),
          child: Form(
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: (context) {
                        return SimpleDialog(
                          alignment: Alignment.center,
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SimpleDialogOption(child: Column(
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Text('Kamera'),
                                    ],
                                  ), onPressed: () {
                                    pickImage(context, true).then((success) {if (success) {Navigator.pop(context);}});
                                  },),
                                  const VerticalDivider(),
                                  SimpleDialogOption(child: Column(
                                    children: [
                                      Icon(Icons.image),
                                      Text('Galerie'),
                                    ],
                                  ), onPressed: () {
                                    pickImage(context, false).then((success) {if (success) {Navigator.pop(context);}});
                                  },),
                                ],
                              ),
                            )
                          ],
                        );
                      },);
                    },
                    child: Container(
                        margin: EdgeInsets.all(15),
                        height: 150,
                        width: 150,
                        child: () {
                          if (_profileImage.isEmpty) {
                            return Stack(children: [
                              Center(
                                  child: Icon(
                                    color: Colors.grey,
                                    Icons.circle,
                                    size: 150,
                                  )),
                              Center(
                                  child: Icon(
                                    color: Colors.white,
                                    Icons.add_a_photo,
                                    size: 80,
                                  )),
                            ]);
                          } else {
                            return Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                clipBehavior: Clip.antiAlias,
                                //child: Image.file(File(_imagePath))
                                child: Image.memory(_profileImage)
                            );
                          }
                        }()),
                  ),
                ),
                DropdownButton<String>(value: 'Gruppe 1',
                  items: [
                    DropdownMenuItem(
                        value: 'Gruppe 1', child: Text('Gruppe 1')),
                    DropdownMenuItem(value: 'Gruppe 2', child: Text('Gruppe 2'))
                  ],
                  onChanged: (value) {
                    setState(() {

                    });
                  },),
                buildTextField(Strings.firstname, 'firstname'),
                buildTextField(Strings.middlename, 'middlename'),
                buildTextField(Strings.lastname, 'lastname'),
                buildTextField(Strings.birthday, 'birthday'),
                Row(
                  children: [
                    Expanded(child: buildTextField(Strings.street, 'street')),
                    Expanded(child: buildTextField(Strings.housenumber, 'housenumber')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: buildTextField(Strings.postcode, 'postcode')),
                    Expanded(child: buildTextField(Strings.city, 'city')),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    ]);
  }

  Widget buildTextField(String label, String? property) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        onChanged: (String? value) {
          if (property != null) student[property] = value;
        },
        scrollPadding: EdgeInsets.all(40),
        decoration:
        InputDecoration(border: OutlineInputBorder(), labelText: label),
      ),
    );
  }

  Future<bool> pickImage(BuildContext context, bool camera) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          cropStyle: CropStyle.circle,
          uiSettings: [
            AndroidUiSettings(
              lockAspectRatio: true,
              initAspectRatio: CropAspectRatioPreset.square,
              hideBottomControls: true,
              //statusBarColor: Theme.of(context).primaryColor,
              toolbarColor: Theme
                  .of(context)
                  .primaryColor,
              backgroundColor: Theme
                  .of(context)
                  .backgroundColor,
            ),
            IOSUiSettings(
              aspectRatioLockEnabled: true,
              aspectRatioPickerButtonHidden: true,
              rectWidth: 1,
              rectHeight: 1,
            )
          ]);
      if (croppedFile != null) {
        setState(() {
          croppedFile.readAsBytes().then((value) => _profileImage = value);
        });
        return Future(() => true);
      }
    }
    return Future(() => false);
  }
}