import 'package:kinga/features/observations/domain/entity/question.dart';

class Observation {

  Question question;
  int? answer;
  String? note;
  String timespan; // for which timespan/year/semester/etc. the observation is made

  Observation(this.question, this.timespan, [this.answer, this.note]);

}
