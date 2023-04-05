import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/entity/question.dart';
import 'package:kinga/features/observations/domain/observation_service.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';

class AnswerObservationQuestionDialog extends StatefulWidget {
  final String studentId;
  final Question question;
  final int? selectedAnswerInitial;
  final String? noteInitial;

  const AnswerObservationQuestionDialog(this.studentId, this.question, {Key? key, this.selectedAnswerInitial, this.noteInitial}) : super(key: key);

  @override
  State<AnswerObservationQuestionDialog> createState() => _AnswerObservationQuestionDialogState();
}

class _AnswerObservationQuestionDialogState extends State<AnswerObservationQuestionDialog> {

  final ObservationService _observationService = GetIt.I<ObservationService>();
  final TextEditingController _notesController = TextEditingController();
  late int selectedAnswer;

  @override
  void initState() {
    selectedAnswer = widget.selectedAnswerInitial != null ? widget.selectedAnswerInitial! : widget.question.possibleAnswers.keys.first;
    if (widget.noteInitial != null) {
      _notesController.text = widget.noteInitial!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return AlertDialog(
      scrollable: true,
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.all(15),
        color: ColorSchemes.kingaGrey.withAlpha(50),
        child: Column(
          children: [
            Text(widget.question.part.title, style: Theme.of(context).textTheme.titleLarge,),
            Text(widget.question.section.title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            LoadingIndicatorDialog.show(context, Strings.loadAnswerObservation);
            _observationService.updateObservation(widget.studentId, Observation(widget.question, "TODO", selectedAnswer, _notesController.text.isNotEmpty ? _notesController.text : null)).then((value) { // TODO: timespan
              GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsAnswerObservation);
              Navigator.of(context).pop(); // pop LoadingIndicatorDialog
              Navigator.of(context).pop(true); // pop CreateObservationDialog with success = true
            });
          },
          child: const Text(Strings.enter),
        )
      ],
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, .0), child: Text(widget.question.text)),
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Column(children:
              (){
                List<Widget> radioButtons = [];
                for (var value in widget.question.possibleAnswers.keys.toList()..sort()) {
                  RadioListTile radioListTile = RadioListTile(visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity), title: Text(widget.question.possibleAnswers[value]!) ,value: value, groupValue: selectedAnswer, onChanged: <int>(value) {
                    setState(() {
                      selectedAnswer = value;
                    },);
                  },);
                  radioButtons.add(radioListTile);
                }

                // add divider if question 0 is available
                if (widget.question.possibleAnswers.containsKey(0)) {
                  radioButtons.insert(1, const Divider());
                }
                return radioButtons.reversed.toList();
              }()
            ,),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _notesController,
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: Strings.notesOptional,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ),
        ],
      ),
    );
  }
}
