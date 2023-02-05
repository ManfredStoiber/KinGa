import 'dart:typed_data';

import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/ui/ObservationStudentDto.dart';

class ObservationStudentDto {

  String studentId;
  String firstname;
  String lastname;
  Uint8List? profileImage;
  List<Observation> observations;

  ObservationStudentDto(
      this.studentId,
      this.firstname,
      this.lastname,
      [ this.profileImage,
        this.observations = const []]
      );

  @override
  int compareTo(ObservationStudentDto other) {
    return "$firstname $lastname $studentId".toLowerCase().compareTo("${other.firstname} ${other.lastname} ${other.studentId}".toLowerCase());
  }

}

