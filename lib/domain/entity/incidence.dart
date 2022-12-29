class Incidence implements Comparable<Incidence> {

  String dateTime; // ISO-String for date and time
  String description;
  String category;
  // Uint8List media; // TODO

  Incidence(this.dateTime, this.description, this.category);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Incidence
        && other.dateTime == dateTime
        && other.description == description
        && other.category == category;
  }

  @override
  int get hashCode => Object.hash(dateTime, description, category);

  @override
  int compareTo(Incidence other) {
    return DateTime.parse(dateTime).compareTo(DateTime.parse(other.dateTime));
  }

}
