import 'package:kinga/features/observations/domain/entity/observation_period.dart';
import 'package:kinga/features/observations/domain/entity/question.dart';

class Observation {

  String id;
  Question question;
  int? answer;
  String? note;
  ObservationPeriod period;

  Observation(this.id, this.question, this.period, [this.answer, this.note]);

}
