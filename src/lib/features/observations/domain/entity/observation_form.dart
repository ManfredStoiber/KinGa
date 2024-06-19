import 'package:kinga/features/observations/domain/entity/question.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part.dart';
import 'package:collection/collection.dart';

class ObservationForm {

  String id;
  String title;
  String version; // ISO-String for dates

  List<ObservationFormPart> parts;

  ObservationForm(this.id, this.title, this.version, this.parts);

  List<Question> getQuestions() {
    List<Question> questions = [];
    for (var part in parts) {
      for (var section in part.sections) {
        questions.addAll(section.questions);
      }
    }
    return questions;
  }

  @override
  bool operator==(Object other) => other is ObservationForm &&
    title == other.title &&
    version == other.version && const DeepCollectionEquality().equals(parts, other.parts);

  @override
  int get hashCode => Object.hashAll([title, version, ...parts]);
}

