import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/absences/ui/absence_screen.dart';
import 'package:kinga/features/incidences/ui/incidence_dialog.dart';
import 'package:kinga/features/incidences/ui/show_incidences_widget.dart';
import 'package:kinga/ui/show_student_data_screen.dart';
import 'package:kinga/ui/widgets/expandable_fab.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowStudentScreen extends StatefulWidget {
  const ShowStudentScreen({Key? key, required this.studentId,}) : super(key: key);

  final String studentId;

  @override
  State<ShowStudentScreen> createState() => _ShowStudentScreenState();
}

class _ShowStudentScreenState extends State<ShowStudentScreen> {


  final _studentService = GetIt.I<StudentService>();
  late final ScrollController _scrollController;
  bool isScrollable = false;
  final _confettiController = ConfettiController(duration: const Duration(seconds: 5));
  final _fabState = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    Student student;
    try {
      student = _studentService.students.firstWhere((student) => student.studentId == widget.studentId);
    } catch (e) {
      Navigator.of(context).pop();
      return Container();
    }

    return WillPopScope(
      onWillPop: () async {
        if (_fabState.currentState?.open ?? false) {
          _fabState.currentState?.toggle();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("${student.firstname}${student.middlename.isNotEmpty ? " ${student.middlename}" : ""} ${student.lastname}"),
          ],
        ),
        actions: [
          Visibility(
            visible: GetIt.I<StudentService>().hasBirthday(student.studentId),
            child: InkWell(onTap: () => setState(() {
              _confettiController.play();
              Future.delayed(const Duration(seconds: 1)).then((value) => _confettiController.stop());
            }), child: Container(padding: const EdgeInsets.only(top: 6), child: Image.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}cupcake.png', height: kToolbarHeight / 2))),
          ),
          IconButton(padding: const EdgeInsets.only(right: 10), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShowStudentDataScreen(student),)), icon: const Icon(Icons.info_outline))
        ],
        ),
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          shrinkWrap: true,
          slivers: [
            SliverPersistentHeader(pinned: true, floating: false, delegate: ShowStudentSliverAppBar(student, _confettiController, expandedHeight: 300.0, collapsedHeight: 100.0,)),
            SliverList(delegate: SliverChildListDelegate.fixed([
              ShowIncidencesWidget(widget.studentId, onIncidencesChanged: () {
                // TODO: like other todo in ShowIncidencesScreen (scrollable)
                /*
                setState(() {
                  isScrollable = (_scrollController.position.maxScrollExtent ?? 0) != 0;
                });
                 */
              },),
            ]),)
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(child: Container(decoration: BoxDecoration(color: ColorSchemes.backgroundColor, boxShadow: [/*if (isScrollable) */BoxShadow(offset: const Offset(0, -1), blurRadius: 0, color: Colors.grey.withAlpha(100))]), height: kToolbarHeight - 10)),
        floatingActionButton: ExpandableFab(
          key: _fabState,
          distance: 150,
          icon: const Icon(Icons.quick_contacts_dialer, color: Colors.white,),
          color: Theme
              .of(context)
              .errorColor,
          children: buildContact(student.caregivers)
          ,
        ),
      ),
    );
  }

  Container buildReadOnlyTextField(String label, String text) {
    TextEditingController controller = TextEditingController();
    controller.text = text;
    if (text.isEmpty) return Container();

    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        enabled: false,
        readOnly: true,
        decoration:
            InputDecoration(border: const OutlineInputBorder(), labelText: label),
        controller: controller,
      ),
    );
  }

  Future<bool> debugPickImage(BuildContext context, bool camera, String studentId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
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
        croppedFile.readAsBytes().then((value) {
          setState(() {
            _studentService.setProfileImage(studentId, value);
          });
        });
        return Future(() => true);
      }
    }
    return Future(() => false);
  }


  List<ActionButton> buildContact(List<Caregiver> caregivers) {
    List<ActionButton> contacts = List.empty(growable: true);
    for (var caregiver in caregivers) {
      caregiver.phoneNumbers.forEach((label, phoneNumber) {
        contacts.add(ActionButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            text: "${caregiver.firstname} ${caregiver.lastname} ($label)",
            onPressed: () async{
              Uri number = Uri.parse('tel:$phoneNumber');
              await launchUrl(number);
            },
        ));
      });
    }
    return contacts;
  }
}

class ShowStudentSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;
  final Student student;
  final ConfettiController _confettiController;

  ShowStudentSliverAppBar(this.student, this._confettiController, {required this.expandedHeight, required this.collapsedHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double progress = min(max(shrinkOffset / (maxExtent - minExtent), 0), 1);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Material(
              color: ColorSchemes.backgroundColor,
              elevation: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5 * (1 - progress) + 5),
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {},// => debugPickImage(context, true, student.studentId), // TOOD: remove
                                  child: Hero(
                                      tag: "hero${student.studentId}",
                                      child: () {
                                        if (student.profileImage.isEmpty) {
                                          return SvgPicture.asset(
                                            'assets${Platform.pathSeparator}images${Platform.pathSeparator}hamster.svg',);
                                        } else {
                                          return Container(margin: const EdgeInsets.only(top: 5), clipBehavior: Clip.antiAlias, decoration: ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(44))), child: Image.memory(student.profileImage));
                                        }
                                      } ()
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60 * (1 - progress),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Opacity(
                      opacity: (1 - progress),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                                side: MaterialStateProperty.all(const BorderSide(color: ColorSchemes.kingacolor, width: 2)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(5000) )),
                              ),

                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AbsenceScreen(student.studentId)));
                              },
                              child: Row(
                                children: [
                                  const Text(Strings.absence),
                                  Container(width: 5,),
                                  const Icon(Icons.event_busy),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                          ),
                          FittedBox(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                                side: MaterialStateProperty.all(const BorderSide(color: ColorSchemes.kingacolor, width: 2)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(5000) )),
                              ),
                              onPressed: () {
                                showDialog<Incidence>(context: context, builder: (context) => IncidenceDialog(
                                    student.studentId
                                ),).then((Incidence? value) {
                                  if (value != null) {

                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.edit_note_rounded,),
                                  Container(width: 5,),
                                  const Text(Strings.incidence),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: GetIt.I<StudentService>().hasBirthday(student.studentId),
              child: Align(
                alignment: Alignment.topLeft,
                child: ConfettiWidget(
                  blastDirection: 0,
                  gravity: 0.05,
                  canvas: Size(constraints.maxWidth, constraints.maxHeight + 50),
                  maxBlastForce: 5, minBlastForce: 2, numberOfParticles: 2, emissionFrequency: 0.02, confettiController: _confettiController, blastDirectionality: BlastDirectionality.directional,
                ),
              ),
            ),
            Visibility(
              visible: GetIt.I<StudentService>().hasBirthday(student.studentId),
              child: Align(
                alignment: Alignment.topRight,
                child: ConfettiWidget(
                  blastDirection: pi,
                  gravity: 0.05,
                  canvas: Size(constraints.maxWidth, constraints.maxHeight + 50),
                  maxBlastForce: 5, minBlastForce: 2, numberOfParticles: 2, emissionFrequency: 0.02, confettiController: _confettiController, blastDirectionality: BlastDirectionality.directional,
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}