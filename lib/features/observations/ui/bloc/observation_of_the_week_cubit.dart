import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/observations/domain/entity/question.dart';
import 'package:kinga/features/observations/domain/observation_service.dart';
import 'package:kinga/features/observations/ui/observation_student_dto.dart';
import 'package:meta/meta.dart';

part 'observation_of_the_week_state.dart';

class ObservationOfTheWeekCubit extends Cubit<ObservationOfTheWeekState> {
  ObservationOfTheWeekCubit() : super(ObservationOfTheWeekInitial()) {
    var observationService = GetIt.I<ObservationService>();
    observationService.getObservationForms().then((value) async {
      var question = await observationService.getObservationOfTheWeekQuestion();
      var allStudents = GetIt.I<StudentService>().students;
      var students = <ObservationStudentDto>[];
      await Future.wait([
        for (var student in allStudents) Future.microtask(() async {
          var observations = await observationService.getObservations(student.studentId);
          student.observations = observations;
          if (observations.firstWhereOrNull((observation) => observation.question == question) != null) {
            students.add(ObservationStudentDto(student.studentId, student.firstname, student.lastname, student.profileImage, student.observations)); // TODO: make deep copy of observations
          }
        })
      ]);

      /*
      .where((student) async {
        var observations = await observationService.getObservations(student.studentId);
        var observation = observations.firstWhereOrNull((observation) => observation.question == question);
        if (observation == null) {
          return false;
        }
        return true;

      });
       */
      if (students.isEmpty) {
        emit (ObservationOfTheWeekEmpty(question));
      } else {
        emit (ObservationOfTheWeekLoaded(question, students));
      }
    });
  }

  setAnswer(String studentId, int answerIndex) {
    if (state is ObservationOfTheWeekLoaded) {
      var state = (this.state as ObservationOfTheWeekLoaded);
      var answers = (state).answers;
      for (var answer in answers.entries) {
        answer.value.remove(studentId);
      }
      answers[answers.keys.elementAt(answerIndex)]?.add(studentId);
      answers[answers.keys.elementAt(answerIndex)]?.sort((a, b) => state.getStudent(a).compareTo(state.getStudent(b)),);
      emit(ObservationOfTheWeekLoaded(state.question, state.students, answers));
    }
  }
}
