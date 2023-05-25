part of 'observation_of_the_week_bar_cubit.dart';

@immutable
abstract class ObservationOfTheWeekBarState {}

class ObservationOfTheWeekBarInitial extends ObservationOfTheWeekBarState {}
class ObservationOfTheWeekBarLoaded extends ObservationOfTheWeekBarState {
  Question question;
  ObservationOfTheWeekBarLoaded(this.question);
}
class ObservationOfTheWeekBarNoQuestion extends ObservationOfTheWeekBarState {}
