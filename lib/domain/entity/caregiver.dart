import 'package:kinga/domain/entity/person.dart';

class Caregiver extends Person {

  String label;
  Map<String, String> phoneNumbers; // key is label, value is phonenumber
  String email;

  Caregiver(firstname, lastname, this.label, this.phoneNumbers, this.email) : super(firstname, lastname);

  Map<String, dynamic> toMap() {
    return {'firstname':firstname, 'lastname':lastname, 'label':label, 'phoneNumbers':phoneNumbers, 'email':email};
  }

}