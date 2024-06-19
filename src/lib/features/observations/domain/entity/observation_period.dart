class ObservationPeriod {
  late int year;
  int number = 0;

  ObservationPeriod(this.year, this.number);
  ObservationPeriod.fromString(String observationPeriod) {
    year = int.parse(observationPeriod.substring(0, 4));
    if (observationPeriod.length > 4) {
      number = int.parse(observationPeriod.substring(4));
    }
  }

  @override
  String toString() {
    return "$year$number";
  }

}