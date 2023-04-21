import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/features/observations/domain/entity/question.dart';
import 'package:kinga/features/observations/domain/observation_service.dart';
import 'package:meta/meta.dart';

part 'observation_of_the_week_bar_state.dart';

class ObservationOfTheWeekBarCubit extends Cubit<ObservationOfTheWeekBarState> {
  ObservationOfTheWeekBarCubit() : super(ObservationOfTheWeekBarInitial()) {
    GetIt.I<ObservationService>().getObservationOfTheWeekQuestion().then((question) {
      if (question != null) {
        emit(ObservationOfTheWeekBarLoaded(question));
      }
      emit(ObservationOfTheWeekBarNoQuestion());
    });
  }
}
