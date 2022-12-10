import 'package:kinga/features/observations/domain/entity/observation_form_part.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part_section.dart';
import 'package:collection/collection.dart';

class ObservationFormPart {

  String title;
  int number;
  List<ObservationFormPartSection> sections;

  ObservationFormPart(this.title, this.number, this.sections);

  @override
  bool operator==(Object other) => other is ObservationFormPart &&
      title == other.title &&
      number == other.number && const DeepCollectionEquality().equals(sections, other.sections);

  @override
  int get hashCode => Object.hashAll([title, number, ...sections]);
}
