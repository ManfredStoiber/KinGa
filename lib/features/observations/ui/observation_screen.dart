import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';

import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part_section.dart';
import 'package:kinga/features/observations/ui/answer_observation_question_dialog.dart';
import 'package:kinga/features/observations/ui/bloc/observations_cubit.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/ui/widgets/drop.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ObservationScreen extends StatelessWidget {
  const ObservationScreen(this.studentId, {Key? key}) : super(key: key);

  final String studentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ObservationsCubit(studentId),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ObservationsCubit, ObservationsState>(
            builder: (context, state) {
              if (state is ObservationsLoaded) {
                ObservationsCubit cubit = BlocProvider.of<ObservationsCubit>(context);
                return Row(
                  children: [
                    Text(Strings.observationForm, style: Theme.of(context).textTheme.titleMedium), // TODO
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(15),
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
                );
              } else {
                return const Text("TODO"); // TODO
              }
            },
          ),
        ),
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
                              BlocProvider.of<ObservationsCubit>(context).createObservationForm(studentId, state.selectedObservationForm!.title, state.selectedObservationForm!.version, "TODO").then((value) => Navigator.of(context).pop()); // TODO: timespan
                            }, child: const Text(Strings.createObservationForm),),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: state.selectedObservationForm?.parts.length ?? 0,
                        itemBuilder: (context, partIndex) {
                          ObservationFormPart? part = state.selectedObservationForm?.parts[partIndex];
                          if (part != null) {
                            return Column(
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
                                      margin: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(15),
                                            margin: const EdgeInsets.only(bottom: 10),
                                            decoration: ShapeDecoration(
                                              color: ColorSchemes.kingaGrey.withAlpha(150),
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0), bottom: Radius.zero)
                                              )
                                            ),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              Text(section.code, textScaleFactor: 1.5,),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(left: 25),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Text(
                                                        section.title,
                                                        textScaleFactor: 1.5,
                                                      ),
                                                      if (section.subtitle != null) Text(section.title),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ]),
                                          ),
                                          // observations
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
                                                    Row(
                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            margin: const EdgeInsets.fromLTRB(.0, 10.0, 5.0, 10.0),
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
                                                            observation.answer != null ?
                                                            Expanded(child: Text(observation.question.possibleAnswers[observation.answer]!)) :
                                                            Expanded(
                                                              child: TextButton(onPressed: (){
                                                                showDialog(context: context, builder: (context) => AnswerObservationQuestionDialog(studentId, observation.question)).then((success) {
                                                                  if (success) {
                                                                    BlocProvider.of<ObservationsCubit>(context).updateUi();
                                                                  }
                                                                });
                                                              } , child: const Text("Eintragen")),
                                                            ),
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
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return const Text("TODO"); // TODO
                          }
                        },
                      ),
                    ),
                  )
                  ],
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
