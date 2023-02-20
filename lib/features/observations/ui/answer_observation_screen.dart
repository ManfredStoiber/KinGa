import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/features/observations/domain/observation_service.dart';
import 'package:kinga/features/observations/ui/ObservationStudentDto.dart';
import 'package:kinga/features/observations/ui/bloc/observation_of_the_week_cubit.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:simple_shadow/simple_shadow.dart';

class AnswerObservationScreen extends StatefulWidget {

  AnswerObservationScreen({Key? key}) : super(key: key);

  @override
  State<AnswerObservationScreen> createState() => _AnswerObservationScreenState();
}

class _AnswerObservationScreenState extends State<AnswerObservationScreen> {

  ScrollController _scrollController = ScrollController();
  final _listViewKey = GlobalKey();

  ValueNotifier<bool> scrollingNotifier = ValueNotifier(false);
  bool _isDragging = false;
  bool _isScrollingUp = false;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    scrollingNotifier.addListener(() async {
      const moveDistance = 3;
      while (_isScrollingUp && scrollingNotifier.value) {
        // code to scroll up
        var to = _scrollController.offset - moveDistance;
        to = (to < 0) ? 0 : to;
        _scrollController.jumpTo(to);
        await Future.delayed(Duration(milliseconds: 5));
      }
      while (_isScrollingDown && scrollingNotifier.value) {
        // code to scroll down
        _scrollController.jumpTo(_scrollController.offset + moveDistance);
        await Future.delayed(Duration(milliseconds: 5));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => ObservationOfTheWeekCubit(),
  child: BlocBuilder<ObservationOfTheWeekCubit, ObservationOfTheWeekState>(
  builder: (context, state) {
    if (state is ObservationOfTheWeekEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Frage der Woche"), // TODO
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(width: double.infinity, padding: EdgeInsets.all(5), color: ColorSchemes.kingacolor, child: Text(textAlign: TextAlign.center, '"${state.question.text}"', style: Theme.of(context).textTheme.titleMedium,)),
            Spacer(),
            Container(margin: const EdgeInsets.all(30), width: 100, child: SimpleShadow(child: Opacity(opacity: 0.4, child: Image.asset('assets/images/no_results.png')))),
            Text(Strings.noObservationsYet, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
            Container(margin: const EdgeInsets.all(20), child: Text(Strings.noObservationsYetDescription, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
            Spacer(flex: 2)
          ],
        ),
      );
    } else if (state is ObservationOfTheWeekLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Frage der Woche"), // TODO
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              saveAnswers(state);
              GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsAnswerObservationOfTheWeek);
              Navigator.of(context).pop();
            },
          child: Icon(Icons.check),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(padding: EdgeInsets.all(5), color: ColorSchemes.kingacolor, child: Text(textAlign: TextAlign.center, '"${state.question.text}"', style: Theme.of(context).textTheme.titleMedium,)),
            Expanded(
              child: _createListener(ListView.builder(
                padding: EdgeInsets.only(bottom: 100),
                  key: _listViewKey,
                  controller: _scrollController,
                  shrinkWrap: true, itemCount: state.answers.keys.length, itemBuilder: (context, answerIndex) {
                    var answerText = answerIndex == 0 ? "Nicht zugeordnet" : state.question.possibleAnswers[state.question.possibleAnswers.keys.elementAt(answerIndex - 1)];
                  return Card(
                    margin: answerIndex == 0 ? EdgeInsets.zero : null,
                    elevation: answerIndex == 0 ? 0 : null,
                    shape: answerIndex == 0 ? RoundedRectangleBorder(borderRadius: BorderRadius.zero) : null,
                    child: DragTarget<String>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          color: candidateData.isNotEmpty ? ColorSchemes.kingacolor.withAlpha(150) : answerIndex == 0 ? ColorSchemes.backgroundColor : Colors.white,
                          child: Column(
                            children: [
                              Text(answerText ?? "TODO", style: Theme.of(context).textTheme.titleLarge,),
                              GridView.builder(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                                itemCount: state.answers[state.answers.keys.elementAt(answerIndex)]?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var widget = Container(height: 100, width: 100, child: ObservationItem(studentId: state.answers[state.answers.keys.elementAt(answerIndex)]?.elementAt(index) ?? "", cubit: BlocProvider.of(context)));
                                  var student = state.getStudent(state.answers[state.answers.keys.elementAt(answerIndex)]?.elementAt(index) ?? "");
                                  return LongPressDraggable<String>(
                                    onDragStarted: () => _isDragging = true,
                                      onDragEnd: (details) => _isDragging = false,
                                      onDraggableCanceled: (velocity, offset) => _isDragging = false,
                                      data: state.answers[state.answers.keys.elementAt(answerIndex)]?.elementAt(index),
                                      childWhenDragging: ObservationItemDisabled(),
                                      feedback: Container(height: 100, width: 100, child: ObservationItemDragged(student)),
                                      child: widget
                                  );
                                }),
                            ],
                          ),
                        );
                      },
                      onAccept: (studentId) {
                        BlocProvider.of<ObservationOfTheWeekCubit>(context).setAnswer(studentId, answerIndex);
                      },
                    ),
                  );
                },),
              ),
            ),
          ],
        ),
      );
    } else { // TODO: error state
      return Scaffold(
        body: LoadingIndicator(),
      );
    }
  },
),
);
  }

  Widget _createListener(Widget child) {
    return Listener(
      child: child,
      onPointerMove: (event) {
        if (!_isDragging) {
          scrollingNotifier.value = false;
          return;
        }
        RenderBox render =
        _listViewKey.currentContext?.findRenderObject() as RenderBox;
        Offset position = render.localToGlobal(Offset.zero);
        double topY = position.dy;  // top position of the widget
        double bottomY = topY + render.size.height; // bottom position of the widget

        const detectedRange = 100;
        if (event.position.dy < topY + detectedRange) {
          // code to scroll up
          _isScrollingUp = true;
          _isScrollingDown = false;
          scrollingNotifier.value = true;
        } else if (event.position.dy > bottomY - detectedRange) {
          // code to scroll down
          _isScrollingUp = false;
          _isScrollingDown = true;
          scrollingNotifier.value = true;
        } else {
          _isScrollingUp = false;
          _isScrollingDown = false;
          scrollingNotifier.value = false;
        }
      },
    );
  }

  void saveAnswers(ObservationOfTheWeekLoaded state) {
    var observationService = GetIt.I<ObservationService>();
    for (var student in state.students) {
      var observation = student.observations.firstWhereOrNull((o) => o.question == state.question);
      if (observation != null) {
        observation.answer = state.getAnswer(student.studentId);
        observationService.updateObservation(student.studentId, observation);
      }
    }
  }
}

class ObservationItem extends StatefulWidget {
  const ObservationItem({Key? key, required this.studentId, required this.cubit}) : super(key: key);

  final ObservationOfTheWeekCubit cubit;
  final String studentId;

  @override
  State<ObservationItem> createState() => ObservationItemState();
}

class ObservationItemState extends State<ObservationItem> {
  BuildContext? attendanceItemContext;

  bool active = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObservationOfTheWeekCubit, ObservationOfTheWeekState>(
        builder: (context, state) {
          if (state is ObservationOfTheWeekLoaded) {
            return Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                      margin: const EdgeInsets.all(5),
                      child: ElevatedButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(5),
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(64.0),
                              ),
                              //shadowColor: Colors.transparent,
                              backgroundColor: ColorSchemes.kingaGrey,
                          ),
                          child: Column(
                              children: [
                                Expanded(
                                  child: () {
                                    Uint8List? profileImage = state.getStudent(widget.studentId).profileImage;
                                    if (profileImage == null) {
                                      return Image.asset(
                                        'assets${Platform.pathSeparator}images${Platform.pathSeparator}squirrel.png',);
                                    } else {
                                      // check if image uses alpha channel
                                      return Container(margin: const EdgeInsets.only(top: 5), clipBehavior: Clip.antiAlias, decoration: ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(44))), child: Image.memory(fit: BoxFit.fitHeight, profileImage));
                                    }
                                  } (),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Text(state.getStudent(widget.studentId).firstname),
                                )
                              ]
                          )
                      )
                  ),
                ]
            );
          } else {
            throw Exception('Invalid State');
          }
        },
      );
  }

  void toggleAttendance() {
    BlocProvider.of<StudentsCubit>(context).toggleAttendance(widget.studentId);
  }
}

class ObservationItemDisabled extends StatelessWidget {
  const ObservationItemDisabled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
            onPressed: () {
            },
            style: TextButton.styleFrom(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(64.0),
              ),
              shadowColor: Colors.black,
              backgroundColor: Colors.transparent,
            ),
            child: Column(
                children: [
                  Spacer(),
                ]
            )
        )
    );
  }
}

class ObservationItemDragged extends StatelessWidget {

  ObservationStudentDto student;

  ObservationItemDragged(this.student, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        children: [
          Container(
              margin: const EdgeInsets.all(5),
              child: ElevatedButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(5),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(64.0),
                    ),
                    //shadowColor: Colors.transparent,
                    backgroundColor: ColorSchemes.kingaGrey,
                  ),
                  child: Column(
                      children: [
                        Expanded(
                            child: () {
                              if (student.profileImage == null) {
                                return Image.asset(
                                  'assets${Platform.pathSeparator}images${Platform.pathSeparator}squirrel.png',);
                              } else {
                                // check if image uses alpha channel
                                return Container(margin: const EdgeInsets.only(top: 5), clipBehavior: Clip.antiAlias, decoration: ShapeDecoration(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(44))), child: Image.memory(fit: BoxFit.fitHeight, student.profileImage!));
                              }
                            } ()
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(student.firstname),
                        )
                      ]
                  )
              )
          ),
        ]
    );
  }
}
