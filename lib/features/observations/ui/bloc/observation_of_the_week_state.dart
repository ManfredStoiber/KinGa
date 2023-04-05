part of 'observation_of_the_week_cubit.dart';

@immutable
abstract class ObservationOfTheWeekState {}

class ObservationOfTheWeekInitial extends ObservationOfTheWeekState {}
class ObservationOfTheWeekLoading extends ObservationOfTheWeekState {}
class ObservationOfTheWeekEmpty extends ObservationOfTheWeekState {
  Question question;
  ObservationOfTheWeekEmpty(this.question);
}
class ObservationOfTheWeekLoaded extends ObservationOfTheWeekState {

  List<ObservationStudentDto> students;
  Question question;
  Map<int, List<String>> answers = {}; // map for answers, -1 for "not answered yet"

  ObservationOfTheWeekLoaded(this.question, this.students, [Map<int, List<String>>? answers]) {
  if (answers == null) {
      this.answers[-1] = [];

      // generate possible answers
      for (var possibleAnswer in question.possibleAnswers.keys) {
        this.answers[possibleAnswer] = [];
      }

      // TODO
      // set every student to "not answered yet" in sorted order
      for (var student in students.sorted((a, b) => a.compareTo(b))) {
        this.answers[student.observations.firstWhereOrNull((o) => o.question == question)?.answer ?? -1]?.add(student.studentId);
      }
    } else {
      this.answers = answers;
    }

  }

  ObservationStudentDto getStudent(String studentId) {
    return students.firstWhere((student) => student.studentId == studentId);
  }

  int? getAnswer(String studentId) {
    for (var entry in answers.entries) {
      if (entry.value.contains(studentId)) {
        if (entry.key == -1) {
          return null;
        }
        return entry.key;
      }
    }

    return null;
  }


}
