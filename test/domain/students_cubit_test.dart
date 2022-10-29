import 'package:flutter_test/flutter_test.dart';
import 'package:kinga/util/date_utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kinga/data/firebase_student_repository.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/students_cubit.dart';

class MockFirebaseStudentRepository extends Mock implements FirebaseStudentRepository {}

void main() {
  MockFirebaseStudentRepository studentRepository = MockFirebaseStudentRepository();
  when(() => studentRepository.watchStudents()).thenAnswer((_) => Stream.empty());
  StudentsCubit studentsCubit = StudentsCubit(studentRepository);

  DateTime dtNow = DateTime.now();
  String now = dtNow.toIso8601String();
  String currentDate = IsoDateUtils.getIsoDateFromIsoDateTime(now);

  String yesterday = dtNow.subtract(Duration(days: 1)).toIso8601String();
  String yesterdaysDate = IsoDateUtils.getIsoDateFromIsoDateTime(yesterday);

  String tomorrow = dtNow.add(Duration(days: 1)).toIso8601String();
  String tomorrowsDate = IsoDateUtils.getIsoDateFromIsoDateTime(tomorrow);

  group('Absences', () {
    test('Absence yesterday until today', () {
      Absence absence = Absence(yesterdaysDate, currentDate,true);
      var list = [absence];
      var absences = studentsCubit.getAbsencesOfToday(list);
      expect(absences, {absence});
    });

    test('Absence yesterday until tomorrow', () {
      Absence absence = Absence(yesterdaysDate,tomorrowsDate,true);
      var list = [absence];
      var absences = studentsCubit.getAbsencesOfToday(list);
      expect(absences, {absence});
    });

    test('Absence today until tomorrow', () {
      Absence absence = Absence(currentDate,tomorrowsDate,true);
      var list = [absence];
      var absences = studentsCubit.getAbsencesOfToday(list);
      expect(absences, {absence});
    });

    test('Absence before today', () {
      String dayBeforeYesterday = dtNow.subtract(Duration(days: 2)).toIso8601String();
      String dayBeforeYesterdaysDate = IsoDateUtils.getIsoDateFromIsoDateTime(dayBeforeYesterday);

      Absence absence = Absence(dayBeforeYesterdaysDate, yesterdaysDate, true);
      var list = [absence];
      var absences = studentsCubit.getAbsencesOfToday(list);
      expect(absences, []);
    });

    test('Absence after today', () {
      String dayAfterTomorrow = dtNow.add(Duration(days: 2)).toIso8601String();
      String dayAfterTomorrowsDate = IsoDateUtils.getIsoDateFromIsoDateTime(dayAfterTomorrow);

      Absence absence = Absence(tomorrowsDate, dayAfterTomorrowsDate, true);
      var list = [absence];
      var absences = studentsCubit.getAbsencesOfToday(list);
      expect(absences, []);
    });

  });
}
