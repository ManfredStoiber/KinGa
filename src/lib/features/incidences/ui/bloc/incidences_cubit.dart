import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/domain/entity/student.dart';

part 'incidences_state.dart';

class IncidencesCubit extends Cubit<IncidencesState> {

  IncidencesState last = IncidencesInitial();

  final StudentService _studentService = GetIt.I<StudentService>();
  StreamSubscription<Set<Student>>? _streamSubscription;
  final String studentId;

  IncidencesCubit(this.studentId) : super(IncidencesInitial()) {
    emit(IncidencesLoading());
    last = IncidencesLoaded(Strings.all, Strings.today, _studentService.getStudent(studentId).incidences);
    emit(last);
    _streamSubscription = _studentService.watchStudents().listen((students) {
      last = state;
      emit(IncidencesLoaded((state as IncidencesLoaded).selectedCategory, (state as IncidencesLoaded).selectedTimeFrame, _studentService.getStudent(studentId).incidences));
    });
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    super.close();
  }

  void onSelectedCategoryChanged(String? newValue) {
    if (newValue != null) {
      last = state;
      emit(IncidencesLoaded(newValue, (state as IncidencesLoaded).selectedTimeFrame, _studentService.getStudent(studentId).incidences));
    }
  }

  void onSelectedTimeFrameChanged(String? newValue) {
    if (newValue != null) {
      last = state;
      emit(IncidencesLoaded((state as IncidencesLoaded).selectedCategory, newValue, _studentService.getStudent(studentId).incidences));
    }
  }

  Future<void> createIncidence(String studentId, Incidence incidence) async {
    return _studentService.createIncidence(studentId, incidence);
  }

  Future<List<Incidence>> getIncidencesOfDays(List<Incidence> incidences, DateTime from, DateTime until) async {
    return _studentService.getIncidencesOfDays(incidences, from, until);
  }

  Future<List<Incidence>> getIncidencesOfToday(List<Incidence> incidences) async {
    return _studentService.getIncidencesOfToday(incidences);
  }

  bool hasIncidences(String studentId) {
    return _studentService.hasIncidences(studentId);
  }

}
