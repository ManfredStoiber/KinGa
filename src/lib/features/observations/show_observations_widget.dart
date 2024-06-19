import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/entity/observation_form.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part_section.dart';
import 'package:kinga/features/observations/domain/entity/observation_period.dart';
import 'package:kinga/features/observations/ui/answer_observation_question_dialog.dart';
import 'package:kinga/features/observations/ui/bloc/observations_cubit.dart';
import 'package:kinga/ui/widgets/drop.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ShowObservationsWidget extends StatefulWidget {
  const ShowObservationsWidget(this.studentId, {Key? key}) : super(key: key);

  final String studentId;

  @override
  State<ShowObservationsWidget> createState() => ShowObservationsWidgetState();
}

class ShowObservationsWidgetState extends State<ShowObservationsWidget> with AutomaticKeepAliveClientMixin<ShowObservationsWidget> {

  ObservationsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        create: (context) => ObservationsCubit(widget.studentId),
        child: BlocBuilder<ObservationsCubit, ObservationsState>(
          builder: (context, state) {
            cubit = BlocProvider.of(context);
            if (state is ObservationsLoaded) {
              ObservationsCubit cubit = BlocProvider.of<ObservationsCubit>(context);
              return Scrollbar(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IntrinsicWidth(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: ColorSchemes.kingacolor, width: 0)), color: ColorSchemes.kingacolor),
                              child: DropdownButtonFormField<ObservationForm?>(
                                style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                decoration: InputDecoration (
                                    isDense: true,
                                    prefixIcon: Container(padding: const EdgeInsets.fromLTRB(10, 5, 5, 5), child: const Icon(size: 20, Icons.switch_account_outlined, color: Colors.black)),
                                    prefixIconConstraints: const BoxConstraints(maxHeight: 30),
                                    enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                    contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5)
                                ),
                                alignment: Alignment.center,
                                value: state.selectedObservationForm,
                                items: (){
                                  List<DropdownMenuItem<ObservationForm?>> dropdownMenuItems = [];
                                  for (var observationForm in state.observationForms) {
                                    dropdownMenuItems.add(DropdownMenuItem(value: observationForm, child: Text(observationForm.title)));
                                  }
                                  return dropdownMenuItems;
                                }(),
                                onChanged: (ObservationForm? newValue) {
                                  cubit.updateUi(selectedObservationForm: newValue);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: ColorSchemes.kingacolor, width: 0)), color: ColorSchemes.kingacolor),
                              child: DropdownButtonFormField<ObservationFormPart?>(
                                selectedItemBuilder: (context) => (){
                                  List<DropdownMenuItem<ObservationFormPart?>> dropdownMenuItems = [];
                                  for (var i = 0; i < state.selectedObservationForm.parts.length; i++) {
                                    dropdownMenuItems.add(DropdownMenuItem(value: state.selectedObservationForm.parts[i], child: Text(maxLines: 1, softWrap: false, overflow: TextOverflow.fade, "Teil ${i+1}: ${state.selectedObservationForm.parts[i].title}")));
                                  }
                                  return dropdownMenuItems;
                                }(),
                                isExpanded: true,
                                style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                decoration: InputDecoration (
                                    isDense: true,
                                    prefixIcon: Container(padding: const EdgeInsets.fromLTRB(10, 5, 5, 5), child: const Icon(size: 20, Icons.numbers, color: Colors.black)),
                                    prefixIconConstraints: const BoxConstraints(maxHeight: 30),
                                    enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                    contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5)
                                ),
                                alignment: Alignment.center,
                                value: state.selectedPart,
                                items: (){
                                  List<DropdownMenuItem<ObservationFormPart?>> dropdownMenuItems = [];
                                  for (var i = 0; i < state.selectedObservationForm.parts.length; i++) {
                                    dropdownMenuItems.add(DropdownMenuItem(value: state.selectedObservationForm.parts[i], child: Text("Teil ${i+1}: ${state.selectedObservationForm.parts[i].title}")));
                                  }
                                  return dropdownMenuItems;
                                }(),
                                onChanged: (ObservationFormPart? newValue) {
                                  cubit.updateUi(selectedPart: newValue);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.observations.isEmpty) Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(margin: const EdgeInsets.only(top: 30), child: Text("${state.selectedObservationForm.title} ${Strings.noObservationFormYet}", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
                              Container(margin: const EdgeInsets.all(30), width: 100, child: SimpleShadow(child: Opacity(opacity: 0.4, child: Image.asset('assets/images/observations.png'.replaceAll('/', Platform.pathSeparator))))),
                              ElevatedButton(onPressed: () {
                                LoadingIndicatorDialog.show(context, Strings.loadCreateObservationForm);
                                BlocProvider.of<ObservationsCubit>(context).createObservationForm(widget.studentId, state.selectedObservationForm.id, ObservationPeriod(2023, 0)).then((value) => context.pop()); // TODO: period
                              }, child: const Text(Strings.createObservationForm),),
                            ],
                          ),
                        ),
                      ],
                    ) else ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.selectedPart.sections.length,
                      itemBuilder: (context, sectionIndex) {
                        Iterable<Observation> observations = state.observations.where((observation) =>
                        observation.question.observationForm == state.selectedObservationForm &&
                            observation.question.part == state.selectedPart &&
                            observation.question.section == state.selectedPart.sections[sectionIndex]
                        ).sorted((a, b) => a.question.number.compareTo(b.question.number));

                        ObservationFormPartSection section = state.selectedPart.sections.elementAt(sectionIndex);
                        // Section
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
                                            showDialog(context: context, builder: (context) => AnswerObservationQuestionDialog(observation.id, widget.studentId, observation.question)).then((success) {
                                              if (success) {
                                                BlocProvider.of<ObservationsCubit>(context).updateUi();
                                              }
                                            });
                                          } , child: const Text("Eintragen")),
                                        ),
                                        if (observation.answer != null) Container(
                                          margin: const EdgeInsets.fromLTRB(.0, 10.0, 5.0, 10.0),
                                          child: InkWell(
                                            onLongPress: () => showDialog(context: context, builder: (context) => AnswerObservationQuestionDialog(observation.id, widget.studentId, observation.question, selectedAnswerInitial: observation.answer, noteInitial: observation.note,),).then((success) {
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
                                                                actions: [TextButton(child: const Text(Strings.close), onPressed: () => context.pop(),)],
                                                                title: const Text(Strings.note),
                                                                content: Text(observation.note!),
                                                              ),);
                                                            },
                                                            icon: Drop(image: Container(padding: const EdgeInsets.only(bottom: 2.0), child: const Text(textAlign: TextAlign.center, "i", style: TextStyle(fontWeight: FontWeight.bold, color: ColorSchemes.kingacolor))), color: ColorSchemes.kingacolor, height: 20, width: 20,),
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
              );
            } else if (state is ObservationsError) {
              return const Center(
                child: Text(Strings.errorOccured),
              );
            } else {
              return Column(
                children: const [
                  LoadingIndicator(),
                ],
              );
            }
          },
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
