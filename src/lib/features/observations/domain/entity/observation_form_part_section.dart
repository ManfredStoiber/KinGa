import 'package:kinga/features/observations/domain/entity/question.dart';
import 'package:collection/collection.dart';

class ObservationFormPartSection {

  String id;
  String title;
  String? subtitle;
  String code;
  List<Question> questions;

  ObservationFormPartSection(this.id, this.title, this.code, this.questions, [this.subtitle]);

  @override
  bool operator==(Object other) => other is ObservationFormPartSection &&
      title == other.title &&
      subtitle == other.subtitle &&
      code == other.code && const DeepCollectionEquality().equals(questions, other.questions);

  @override
  int get hashCode => Object.hashAll([title, subtitle, code, ...questions]);
}