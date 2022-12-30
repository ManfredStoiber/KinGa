import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';

import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part_section.dart';
import 'package:kinga/features/observations/ui/answer_observation_question_dialog.dart';
import 'package:kinga/features/observations/ui/bloc/observations_cubit.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/ui/widgets/drop.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ObservationScreen extends StatefulWidget {
  const ObservationScreen(this.studentId, {Key? key}) : super(key: key);

  final String studentId;

  @override
  State<ObservationScreen> createState() => _ObservationScreenState();
}

class _ObservationScreenState extends State<ObservationScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ObservationsCubit(widget.studentId),
      child: BlocBuilder<ObservationsCubit, ObservationsState>(
  builder: (context, state) {
    if (state is ObservationsLoaded) {
      ObservationsCubit cubit = BlocProvider.of<ObservationsCubit>(context);
      return DefaultTabController(
        length: (state as ObservationsLoaded).selectedObservationForm!.parts.length,
        child: Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              var student = GetIt.I<StudentService>().getStudent(widget.studentId);
              return [
                SliverPersistentHeader(pinned: true, floating: true, delegate: _HeaderDelegate(student, cubit, state, this, MediaQuery.of(context).viewPadding.top)),
                /*
                SliverAppBar(
                  snap: true,
                  floating: true,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  title: Row(
                    children: [
                      Text(Strings.observationForm, style: Theme.of(context).textTheme.titleMedium), // TODO
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<String?>(
                            style: Theme.of(context).textTheme.titleMedium,
                            underline: Container(height: 1, color: Colors.black38,),
                            isExpanded: false,
                            value: state.selectedObservationForm?.title,
                            items: state.observationForms.map((e) => DropdownMenuItem(value: e.title, child: Text(e.title))).toList(),
                            onChanged: (String? newValue) {
                              cubit.updateUi(selectedObservationForm: newValue);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: TabBar(
                      indicatorColor: Colors.white,
                      tabs: (state as ObservationsLoaded).selectedObservationForm!.parts.map((part) => Tab(text: part.title,)).toList(),
                    ),
                  ),
                )

                 */
              ];
            },
            body: BlocBuilder<ObservationsCubit, ObservationsState>(
              builder: (context, state) {
                if (state is ObservationsLoaded) {
                  if (state.observationForms.isEmpty) {
                    return const Text("TODO"); // TODO
                  } else {
                    if (state.observations.isEmpty) {
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${state.selectedObservationForm!.title} ${Strings.noObservationFormYet}", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
                                Container(margin: const EdgeInsets.all(30), width: 200, child: SimpleShadow(child: Opacity(opacity: 0.4, child: Image.asset('assets/images/observations.png'.replaceAll('/', Platform.pathSeparator))))),
                                ElevatedButton(onPressed: () {
                                  LoadingIndicatorDialog.show(context);
                                  BlocProvider.of<ObservationsCubit>(context).createObservationForm(widget.studentId, state.selectedObservationForm!.title, state.selectedObservationForm!.version, "TODO").then((value) => Navigator.of(context).pop()); // TODO: timespan
                                }, child: const Text(Strings.createObservationForm),),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    /*
                     */
                return TabBarView(
                  children: (state as ObservationsLoaded).selectedObservationForm!.parts.map((part) => ListView(
                    shrinkWrap: true,
                    children: [
                      Scrollbar(
                        child: Column(
                          children: [
                            Container(padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0), child: Text("Teil ${part.number}:", style: Theme.of(context).textTheme.headlineSmall)),
                            Container(padding: const EdgeInsets.all(10.0), child: Text(textAlign: TextAlign.center, part.title, style: Theme.of(context).textTheme.titleLarge)),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: part.sections.length,
                              itemBuilder: (context, sectionIndex) {
                                Iterable<Observation> observations = state.observations.where((observation) =>
                                observation.question.observationForm == state.selectedObservationForm &&
                                    observation.question.part == part &&
                                    observation.question.section == part.sections[sectionIndex]
                                ).sorted((a, b) => a.question.number.compareTo(b.question.number));

                                ObservationFormPartSection section = part.sections.elementAt(sectionIndex);
                                // Section
                                return Card(
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: ExpansionTile(
                                    title: Container(
                                      //padding: const EdgeInsets.all(15),
                                      //margin: const EdgeInsets.only(bottom: 10),
                                      /*

                                      decoration: ShapeDecoration(
                                          color: ColorSchemes.kingaGrey.withAlpha(150),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0), bottom: Radius.zero)
                                          )
                                      ),

                                       */
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Text(section.code),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 25),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  section.title,
                                                ),
                                                if (section.subtitle != null) Text(section.title),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) => const Divider(),
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: observations.length,
                                          itemBuilder: (context, observationIndex) {
                                            Observation observation = observations.elementAt(observationIndex);
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(padding: const EdgeInsets.all(15), child: Text(observation.question.number.toString(), textScaleFactor: 1.5,)),
                                                    Expanded(child: Container(padding: const EdgeInsets.only(right: 10.0), child: Text(observations.elementAt(observationIndex).question.text,))),
                                                  ],
                                                ),
                                                if (observation.answer == null) SizedBox(
                                                  width: double.infinity,
                                                  child: TextButton(onPressed: (){
                                                    showDialog(context: context, builder: (context) => AnswerObservationQuestionDialog(widget.studentId, observation.question)).then((success) {
                                                      if (success) {
                                                        BlocProvider.of<ObservationsCubit>(context).updateUi();
                                                      }
                                                    });
                                                  } , child: const Text("Eintragen")),
                                                ),
                                                if (observation.answer != null) Container(
                                                  margin: const EdgeInsets.fromLTRB(.0, 10.0, 5.0, 10.0),
                                                  child: InkWell(
                                                    onLongPress: () => showDialog(context: context, builder: (context) => AnswerObservationQuestionDialog(widget.studentId, observation.question, selectedAnswerInitial: observation.answer, noteInitial: observation.note,),).then((success) {
                                                      if (success) {
                                                        BlocProvider.of<ObservationsCubit>(context).updateUi();
                                                      }
                                                    }),
                                                    child: Row(
                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                              padding: const EdgeInsets.fromLTRB(.0, 5.0, 5.0, 5.0),
                                                              decoration: observation.answer != null ? ShapeDecoration( color: ColorSchemes.kingacolor.withAlpha(50), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(15)))) : null,
                                                              child: Row(children: [
                                                                if (observation.answer != null) Visibility(
                                                                  replacement: Container(margin: const EdgeInsets.symmetric(horizontal: 11.0), width: 20.0, height: .0,),
                                                                  visible: observation.note != null,
                                                                  child: IconButton(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    onPressed: () {
                                                                      showDialog(context: context, builder: (context) => AlertDialog(
                                                                        contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, .0),
                                                                        actions: [TextButton(child: const Text(Strings.close), onPressed: () => Navigator.of(context).pop(),)],
                                                                        title: const Text(Strings.note),
                                                                        content: Text(observation.note!),
                                                                      ),);
                                                                    },
                                                                    icon: Drop(image: Container(padding: const EdgeInsets.only(bottom: 2.0), child: Text(textAlign: TextAlign.center, "i", style: TextStyle(fontWeight: FontWeight.bold, color: ColorSchemes.kingacolor))), color: ColorSchemes.kingacolor, height: 20, width: 20,),
                                                                    visualDensity: VisualDensity.compact,
                                                                  ),
                                                                ),
                                                                if (observation.answer != null)
                                                                  Expanded(child: Text(observation.question.possibleAnswers[observation.answer]!))
                                                              ])),
                                                        ),
                                                        if (observation.answer != null) Container(
                                                          padding: const EdgeInsets.only(right: 5.0),
                                                          child: Row(
                                                              children: (){
                                                                List<Widget> radioButtons = [];
                                                                if (observation.answer != null) {
                                                                  for (var key in observation.question.possibleAnswers.keys) {
                                                                    if (key != 0) {
                                                                      radioButtons.add(Radio(visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, value: key, groupValue: observation.answer, onChanged: (value) {},));
                                                                    }
                                                                  }
                                                                  // add invisible radio buttons for correct spacing
                                                                  for (var i = 0; i < 6 - observation.question.possibleAnswers.keys.length; i++) {
                                                                    radioButtons.add(Visibility(visible: false, maintainAnimation: true, maintainState: true, maintainSize: true, child: Radio(visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, value: i, groupValue: i, onChanged: (value) {},)));
                                                                  }

                                                                  // answer 0 ("not available")
                                                                  //   add vertical divider if answer 0 possible
                                                                  bool answer0Possible = observation.question.possibleAnswers.keys.contains(0);
                                                                  if (answer0Possible) {
                                                                    radioButtons.add(Container(color: ColorSchemes.absentColor, width: 1, height: 15,));
                                                                  }
                                                                  //   add radio button for answer 0
                                                                  radioButtons.add(Visibility(visible: answer0Possible, maintainAnimation: true, maintainState: true, maintainSize: true, child: Radio(visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, value: 0, groupValue: observation.answer, onChanged: (value) {},)));
                                                                }
                                                                return radioButtons;
                                                              }()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )).toList()
                      /*
                  children: [

                  ],

                       */
                  ,
                );
                  }

                } else if (state is ObservationsError) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Navigator.of(context).pop()); // close screen on error
                  return const Text("TODO: add error screen"); // TODO
                } else {
                  return const LoadingIndicator();
                }
              },
            ),
          ),
        ),
      );
    } else {
      return Scaffold(body: LoadingIndicator(),);
    }
  },
),
    );
  }

  Widget selectedDayWidget() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: ColorSchemes.kingacolor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget todayWidget() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorSchemes.kingacolor.withAlpha(150),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {

  final double viewPaddingTop;
  final Student student;
  final ObservationsCubit cubit;
  final ObservationsLoaded state;

  _HeaderDelegate(this.student, this.cubit, this.state, this.vsync, this.viewPaddingTop);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double progress = min(max(shrinkOffset / (maxExtent - minExtent), 0), 1);
    return Container(color: ColorSchemes.kingacolor, child: Stack(
      children: [
        Column(
          children: [
            AppBar(
              elevation: 0,
              title: Container(margin: EdgeInsets.only(right: 120 * (progress)), child: Text("${student.firstname} ${student.lastname}")),
            ),
            Container(
              margin: EdgeInsets.only(top: kToolbarHeight * (1 - progress)),
              height: kToolbarHeight,
              child: TabBar(
                indicatorColor: Colors.white,
                tabs: (state as ObservationsLoaded).selectedObservationForm!.parts.map((part) => Tab(text: part.title,)).toList(),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: viewPaddingTop + kToolbarHeight * (1 - progress) + 5),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Opacity(opacity: 1 - min((progress * 1.5), 1), child: Text(Strings.observationForm, style: Theme.of(context).textTheme.titleLarge)),
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButton<String?>(
                  style: Theme.of(context).textTheme.titleLarge,
                  underline: Container(height: 1, color: Colors.black38,),
                  isExpanded: false,
                  value: state.selectedObservationForm?.title,
                  items: (){
                    List<DropdownMenuItem<String?>> dropdownMenuItems = [];
                    for (var observationForm in state.observationForms) {
                      dropdownMenuItems.add(DropdownMenuItem(value: observationForm.title, child: Text(observationForm.title)));
                    }
                    return dropdownMenuItems;
                  }(),
                  onChanged: (String? newValue) {
                    cubit.updateUi(selectedObservationForm: newValue);
                  },
                ),
              ),
            ],
          ),
        )

      ],
    ));
  }

  @override
  double get maxExtent => kToolbarHeight * 3 + viewPaddingTop;

  @override
  double get minExtent => kToolbarHeight * 2 + viewPaddingTop;

  @override
  final TickerProvider vsync;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => FloatingHeaderSnapConfiguration(
    curve: Curves.linear,
    duration: const Duration(milliseconds: 100),
  );

}