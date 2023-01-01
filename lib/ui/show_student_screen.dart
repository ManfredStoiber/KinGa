import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/absences/ui/absence_screen.dart';
import 'package:kinga/features/absences/ui/bloc/absences_cubit.dart';
import 'package:kinga/features/absences/ui/show_absences_widget.dart';
import 'package:kinga/features/incidences/ui/create_incidence_dialog.dart';
import 'package:kinga/features/incidences/ui/show_incidences_widget.dart';
import 'package:kinga/features/observations/show_observations_widget.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';
import 'package:kinga/ui/edit_student_screen.dart';
import 'package:kinga/features/observations/ui/observation_screen.dart';
import 'package:kinga/ui/emergency_bottom_sheet.dart';
import 'package:kinga/ui/show_student_data_widget.dart';
import 'package:kinga/ui/widgets/animated_tab_bar.dart';
import 'package:kinga/ui/widgets/expandable_fab.dart';
import 'package:kinga/util/shared_prefs_utils.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

class ShowStudentScreen extends StatefulWidget {
  const ShowStudentScreen({Key? key, required this.studentId,}) : super(key: key);

  final String studentId;

  @override
  State<ShowStudentScreen> createState() => _ShowStudentScreenState();
}

class _ShowStudentScreenState extends State<ShowStudentScreen>
    with SingleTickerProviderStateMixin {
  final List<String> allShowcases = [Keys.emergencyContactsKey, Keys.showIncidenceWidgetKey, Keys.createIncidenceKey, Keys.showObservationsWidgetKey, Keys.editObservationsKey, Keys.showAbsencesWidgetKey, Keys.createAbsenceKey, Keys.showStudentDataKey, Keys.editStudentDataKey];
  Map<String, GlobalKey> showcaseKeys = {};
  List<GlobalKey> showcases = [];
  List<String> locallyFinishedShowcases = [];

  final SliverOverlapAbsorberHandle headerHandle = SliverOverlapAbsorberHandle();
  final SliverOverlapAbsorberHandle tabBarHandle = SliverOverlapAbsorberHandle();

  final _studentService = GetIt.I<StudentService>();
  late final ScrollController _scrollController;
  bool isScrollable = false;
  final _confettiController = ConfettiController(duration: const Duration(seconds: 5));
  final _fabState = GlobalKey<ExpandableFabState>();
  BuildContext? showStudentContext;

  int _tabIndex = 0;
  late TabController _tabController;

  final _incidencesListKey = GlobalKey<AnimatedListState>(debugLabel: "Test");

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _confettiController.play();

    _tabController = TabController(length: 4, vsync: this);

    _tabController.animation!.addListener(() {
      if (_tabController.animation!.value.round() != _tabIndex) {
        _tabIndex = _tabController.animation!.value.round();
      }
    });
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });

    List<String> finishedShowcases = GetIt.instance.get<StreamingSharedPreferences>().getStringList(Keys.finishedShowcases, defaultValue: []).getValue();
    List<String> missingShowcases = List.from(allShowcases.where((element) => !finishedShowcases.contains(element),));
    for (var showcase in missingShowcases) {
      showcaseKeys[showcase] = GlobalKey();
      var key = showcaseKeys[showcase];
      if (key != null) {
        showcases.add(key);
      }
    }

    if (showcases.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 400), () {
          ShowCaseWidget.of(showStudentContext!).startShowCase(showcases);
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    List<String> finishedShowcases = GetIt.instance.get<StreamingSharedPreferences>().getStringList(Keys.finishedShowcases, defaultValue: []).getValue();
    finishedShowcases.addAll(locallyFinishedShowcases);
    GetIt.instance.get<StreamingSharedPreferences>().setStringList(Keys.finishedShowcases, finishedShowcases);
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

    var cubit = BlocProvider.of<StudentsCubit>(context);
    var color = cubit.isAbsent(student.studentId) ? ColorSchemes.absentColor : cubit.isAttendant(student.studentId) ? ColorSchemes.attendantColor : ColorSchemes.notAttendantColor;

    return ShowCaseWidget(
        autoPlay: true,
        enableAutoPlayLock: true,
        autoPlayDelay: const Duration(days: 42),
        builder: Builder(
          builder: (context) {
            showStudentContext = context;
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
                backgroundColor: ColorSchemes.kingacolor,
                /*
        appBar: ,

         */
                body: ExtendedNestedScrollView(
                  onlyOneScrollInBody: true,
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    // These are the slivers that show up in the "outer" scroll view.
                    return <Widget>[
                      SliverOverlapAbsorber(
                        // This widget takes the overlapping behavior of the SliverAppBar,
                        // and redirects it to the SliverOverlapInjector below. If it is
                        // missing, then it is possible for the nested "inner" scroll view
                        // below to end up under the SliverAppBar even when the inner
                        // scroll view thinks it has not been scrolled.
                        // This is not necessary if the "headerSliverBuilder" only builds
                        // widgets that do not overlap the next sliver.
                        handle: headerHandle,
                        sliver: SliverPersistentHeader(pinned: true, floating: false, delegate: _SliverHeaderDelegate(student, _confettiController, color, expandedHeight: 300.0, collapsedHeight: 150.0, viewPaddingTop: MediaQuery.of(context).viewPadding.top)),
                      ),
                      SliverOverlapAbsorber(
                        handle: tabBarHandle,
                        sliver: SliverPersistentHeader(pinned: true, delegate: _SliverTabBarDelegate(
                            AnimatedTabBar(
                              controller: _tabController,
                              tabs: [
                                Tab(
                                    icon: Showcase(
                                      key: showcaseKeys[Keys.showIncidenceWidgetKey] ?? GlobalKey(),
                                      description: Strings.showIncidenceWidgetTooltip,
                                      targetPadding: const EdgeInsets.fromLTRB(20, -10, 20, 10),
                                      disposeOnTap: true,
                                      onToolTipClick: () {
                                        setState(() {
                                          continueShowcase(Keys.showIncidenceWidgetKey);
                                        });
                                      },
                                      onTargetClick: () {
                                        setState(() {
                                          _tabController.animateTo(0);
                                          continueShowcase(Keys.showIncidenceWidgetKey);
                                        });
                                      },
                                      child: const Icon(Icons.edit_note_rounded)),
                                    text: Strings.tabIncidences
                                ),
                                Tab(
                                    icon: Showcase(
                                        key: showcaseKeys[Keys.showObservationsWidgetKey] ?? GlobalKey(),
                                        description: Strings.showObservationsWidgetTooltip,
                                        targetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        disposeOnTap: true,
                                        onToolTipClick: () {
                                          setState(() {
                                            continueShowcase(Keys.showObservationsWidgetKey);
                                          });
                                        },
                                        onTargetClick: () {
                                          setState(() {
                                            _tabController.animateTo(1);
                                            continueShowcase(Keys.showObservationsWidgetKey);
                                          });
                                        },
                                        child: const Icon(Icons.auto_graph)),
                                    text: Strings.tabObservations
                                ),
                                Tab(
                                    icon: Showcase(
                                      key: showcaseKeys[Keys.showAbsencesWidgetKey] ?? GlobalKey(),
                                      description: Strings.showAbsencesWidgetTooltip,
                                      targetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      disposeOnTap: true,
                                      onToolTipClick: () {
                                        setState(() {
                                          continueShowcase(Keys.showAbsencesWidgetKey);
                                        });
                                      },
                                      onTargetClick: () {
                                        setState(() {
                                          _tabController.animateTo(2);
                                          continueShowcase(Keys.showAbsencesWidgetKey);
                                        });
                                      },
                                      child: const Icon(Icons.event_busy)),
                                    text: Strings.tabAbsences
                                ),
                                Tab(
                                    icon: Showcase(
                                      key: showcaseKeys[Keys.showStudentDataKey] ?? GlobalKey(),
                                      description: Strings.showStudentDataTooltip,
                                      targetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      disposeOnTap: true,
                                      onToolTipClick: () {
                                        setState(() {
                                          continueShowcase(Keys.showStudentDataKey);
                                        });
                                      },
                                      onTargetClick: () {
                                        setState(() {
                                          _tabController.animateTo(3);
                                          continueShowcase(Keys.showStudentDataKey);
                                        });
                                      },
                                      child: const Icon(Icons.info_outline)),
                                    text: Strings.tabStudentData
                                ),
                              ],
                            ),
                            color
                        )),
                      ),
                    ];
                  },
                  body: Stack(
                    children: [
                      Container(
                        color: ColorSchemes.backgroundColor,
                        child: TabBarView(
                          controller: _tabController,
                          // These are the contents of the tab views, below the tabs.
                          children: [
                            ShowIncidencesWidget(widget.studentId, _incidencesListKey, onIncidencesChanged: () {
                              // TODO: like other todo in ShowIncidencesScreen (scrollable)
                              /*
                                setState(() {
                                    isScrollable = (_scrollController.position.maxScrollExtent ?? 0) != 0;
                                });
                                 */
                            },

                            ),
                            //ListView.builder(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), itemCount: 30, itemExtent: 48.0, itemBuilder: (context, index) => Text("Test $index"),),
                            ShowObservationsWidget(widget.studentId),
                            BlocProvider(
                              create: (context) => AbsencesCubit(widget.studentId, DateTime.now()),
                              child: ShowAbsencesWidget(widget.studentId, DateTime.now()),
                            ),
                            ShowStudentDataWidget(student),
                  ].map((Widget w) {
                    return SafeArea(
                      top: false,
                      bottom: false,
                      child: Builder(
                        // This Builder is needed to provide a BuildContext that is
                        // "inside" the NestedScrollView, so that
                        // sliverOverlapAbsorberHandleFor() can find the
                        // NestedScrollView.
                        builder: (BuildContext context) {
                          return CustomScrollView(
                            shrinkWrap: true,
                            //physics: NeverScrollableScrollPhysics(),
                            // The "controller" and "primary" members should be left
                            // unset, so that the NestedScrollView can control this
                            // inner scroll view.
                            // If the "controller" property is set, then this scroll
                            // view will not be associated with the NestedScrollView.
                            // The PageStorageKey should be unique to this ScrollView;
                            // it allows the list to remember its scroll position when
                            // the tab view is not on the screen.
                            //key: PageStorageKey<Widget>(w),
                            slivers: <Widget>[
                              SliverOverlapInjector( handle: headerHandle ),
                              SliverOverlapInjector( handle: tabBarHandle ),
                              SliverToBoxAdapter(child: w,)
                            ],
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(height: 20, color: ColorSchemes.kingacolor), // to fill out one pixel gap between AppBar and header sliver
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: Container(color: ColorSchemes.backgroundColor,
          child: Showcase(
            key: showcaseKeys[Keys.emergencyContactsKey] ?? GlobalKey(),
            description: Strings.emergencyContactsTooltip,
            targetBorderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
            disposeOnTap: true,
            onToolTipClick: () {
              setState(() {
                continueShowcase(Keys.emergencyContactsKey);
              });
            },
            onTargetClick: () {
              setState(() {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return EmergencyBottomSheet(student.caregivers);
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30)
                      )
                  ),
                  isScrollControlled: true,
                ).then((value) {
                  continueShowcase(Keys.emergencyContactsKey);
                });
              });
            },
            child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
              child: BottomAppBar(color: ColorSchemes.errorColor, shape: const CircularNotchedRectangle(), notchMargin: 5.0, child: SizedBox(height: kToolbarHeight - 10,
                child: IconButton(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(padding: const EdgeInsets.only(right: 15), child: const Icon(Icons.contact_phone, color: Colors.white,)),
                      const Text(Strings.contact, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return EmergencyBottomSheet(student.caregivers);
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30)
                        )
                      ),
                      isScrollControlled: true,
                    );
                },),
              )),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            heroTag: 'fabae',
            onPressed: () {
              switch(_tabIndex) {
                case 0:
                  showDialog<Incidence>(context: context, builder: (context) =>
                      CreateIncidenceDialog(
                          student.studentId
                      ),).then((Incidence? value) {
                        if (value != null) {

                          }
                        });
                        break;
                    case 1:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ObservationScreen(student.studentId)));
                      break;
                    case 2:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AbsenceScreen(student.studentId)));
                      break;
                    case 3:
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditStudentScreen(student: student,)));
                      break;
                      }
                    },
                    child: Stack(
                      children: [
                        FadeTransition(
                            opacity: Tween(begin: 0.0, end: 1.0).animate(ShiftingAnimation(_tabController, 0)),
                            child: Showcase(
                              key: showcaseKeys[Keys.createIncidenceKey] ?? GlobalKey(),
                              description: Strings.createIncidenceTooltip,
                              targetShapeBorder: const CircleBorder(),
                              targetPadding: const EdgeInsets.all(15),
                              disposeOnTap: true,
                              onToolTipClick: () {
                                setState(() {
                                  continueShowcase(Keys.createIncidenceKey);
                                });
                              },
                              onTargetClick: () {
                                setState(() {
                                  continueShowcase(Keys.createIncidenceKey);
                                });
                              },
                              child: const Icon(Icons.add)
                            )
                        ),
                        FadeTransition(
                            opacity: Tween(begin: 0.0, end: 1.0).animate(ShiftingAnimation(_tabController, 1)),
                            child: Stack(
                              children: [
                                Visibility(
                                  visible: _tabIndex == 1,
                              child: Showcase(
                                  key: showcaseKeys[Keys.editObservationsKey] ?? GlobalKey(),
                                  description: Strings.editObservationsTooltip,
                                  targetShapeBorder: const CircleBorder(),
                                  targetPadding: const EdgeInsets.all(15),
                                  disposeOnTap: true,
                                  onToolTipClick: () {
                                    setState(() {
                                      continueShowcase(Keys.editObservationsKey);
                                    });
                                  },
                                  onTargetClick: () {
                                    setState(() {
                                      continueShowcase(Keys.editObservationsKey);
                                    });
                                  },
                                  child: const Icon(Icons.edit)
                                  ),
                                ),
                                const Icon(Icons.edit)
                              ],
                            )
                        ),
                        FadeTransition(
                            opacity: Tween(begin: 0.0, end: 1.0).animate(ShiftingAnimation(_tabController, 2)),
                            child: Stack(
                              children: [
                                Visibility(
                                  visible: _tabIndex == 2,
                                  child: Showcase(
                                    key: showcaseKeys[Keys.createAbsenceKey] ?? GlobalKey(),
                                    description: Strings.createAbsenceTooltip,
                                    targetShapeBorder: const CircleBorder(),
                                    targetPadding: const EdgeInsets.all(15),
                                    disposeOnTap: true,
                                    onToolTipClick: () {
                                      setState(() {
                                        continueShowcase(Keys.createAbsenceKey);
                                      });
                                    },
                                    onTargetClick: () {
                                      setState(() {
                                        continueShowcase(Keys.createAbsenceKey);
                                      });
                                    },
                                    child: const Icon(Icons.calendar_month)
                                  ),
                                ),
                                const Icon(Icons.calendar_month)
                              ],
                            )
                        ),
                        FadeTransition(
                            opacity: Tween(begin: 0.0, end: 1.0).animate(ShiftingAnimation(_tabController, 3)),
                            child: Stack(
                              children: [
                                Visibility(
                                  visible: _tabIndex == 3,
                                  child: Showcase(
                                    key: showcaseKeys[Keys.editStudentDataKey] ?? GlobalKey(),
                                    description: Strings.editStudentDataTooltip,
                                    targetShapeBorder: const CircleBorder(),
                                    targetPadding: const EdgeInsets.all(15),
                                    disposeOnTap: true,
                                    onToolTipClick: () {
                                      setState(() {
                                        continueShowcase(Keys.editStudentDataKey);
                                      });
                                    },
                                    onTargetClick: () {
                                      setState(() {
                                        continueShowcase(Keys.editStudentDataKey);
                                      });
                                    },
                                    child: const Icon(Icons.edit)
                                  ),
                                ),
                                const Icon(Icons.edit)
                              ],
                            )
                        ),
                      ],
                    )
                ),
              ),
            );
        },
      )
    );
  }

  void continueShowcase(String key) {
    showcases.remove(showcaseKeys[key]);
    locallyFinishedShowcases.add(key);
    if (key != Keys.editStudentDataKey) {
      ShowCaseWidget.of(showStudentContext!).startShowCase(showcases);
    }
    SharedPrefsUtils.updateFinishedShowcases(key);
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
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;
  final double viewPaddingTop;
  final Student student;
  final ConfettiController _confettiController;
  final Color _backgroundColor;

  _SliverHeaderDelegate(this.student, this._confettiController, this._backgroundColor, {required this.expandedHeight, required this.collapsedHeight, this.viewPaddingTop = 0.0});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = min(max(shrinkOffset / (maxExtent - minExtent), 0), 1);
    return Container(
      color: _backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: kToolbarHeight + viewPaddingTop,
                child: AppBar(
                  backgroundColor: _backgroundColor,
                  elevation: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${student.firstname}${student.middlename.isNotEmpty ? " ${student.middlename}" : ""} ${student.lastname}"),
                    ],
                  ),
                  actions: [
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10 * (1 - progress) + 10),
                        child: InkWell(
                          onTap: () {},// => debugPickImage(context, true, student.studentId), // TOOD: remove
                          child: Hero(
                              tag: "hero${student.studentId}",
                              child: () {
                                if (student.profileImage == null) {
                                  return Image.asset(
                                    'assets${Platform.pathSeparator}images${Platform.pathSeparator}squirrel.png',);
                                } else {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      //shadows: [BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0.0, 5.0))],
                                      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(64 + (1 - progress) * 64))),
                                      child: Image.memory(student.profileImage!
                                    )
                                  );
                                }
                              } ()
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: GetIt.I<StudentService>().hasBirthday(student.studentId),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ConfettiWidget(
                          blastDirection: 0,
                          gravity: 0.05,
                          canvas: Size(constraints.maxWidth, constraints.maxHeight - kToolbarHeight),
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
                          canvas: Size(constraints.maxWidth, constraints.maxHeight - kToolbarHeight),
                          maxBlastForce: 5, minBlastForce: 2, numberOfParticles: 2, emissionFrequency: 0.02, confettiController: _confettiController, blastDirectionality: BlastDirectionality.directional,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Visibility(
                          visible: GetIt.I<StudentService>().hasBirthday(student.studentId),
                          child: InkWell(onTap: () {
                            _confettiController.play();
                            Future.delayed(const Duration(seconds: 1)).then((value) => _confettiController.stop());
                          },
                              child: SimpleShadow(opacity: 0.4, child: Image.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}cupcake.png', height: 60))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + kToolbarHeight + viewPaddingTop;

  @override
  double get minExtent => collapsedHeight + kToolbarHeight + viewPaddingTop;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar, this._backgroundColor);

  final AnimatedTabBar _tabBar;
  final Color _backgroundColor;

  @override
  double get minExtent => 60; // TODO
  @override
  double get maxExtent => 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Container(margin: EdgeInsets.only(bottom: 10), color: _backgroundColor),
        Material(
          color: Colors.transparent,
          elevation: shrinkOffset > maxExtent - minExtent ? 1 : 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: const BoxDecoration(
              color: ColorSchemes.backgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            child: _tabBar,
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}



