import 'package:kinga/features/observations/domain/entity/observation_form.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part_section.dart';

class Question {

  String id;
  late ObservationForm observationForm;
  ObservationFormPart part;
  ObservationFormPartSection section;
  String text;
  int number;
  Map<int, String> possibleAnswers;


  Question(this.id, this.text, this.number, this.possibleAnswers, this.observationForm, this.part, this.section);

  @override
  bool operator==(Object other) => other is Question &&
      text == other.text &&
      number == other.number; // TODO: add possibleAnswers

  @override
  int get hashCode => Object.hashAll([text, number]); // TODO: add possibleAnswers
}
