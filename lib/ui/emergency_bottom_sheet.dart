import 'package:flutter/material.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyBottomSheet extends StatelessWidget {
  EmergencyBottomSheet(this.caregivers, {Key? key}) : super(key: key);

  List<Caregiver> caregivers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: ColorSchemes.errorColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.0),
          ),
        ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(padding: const EdgeInsets.only(right: 15), child: const Icon(Icons.contact_phone, color: Colors.white,)),
                    const Text(Strings.contact, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ],
                )
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.0),
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: ListView.separated(itemBuilder: (context, index) {
                    return IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: const Icon(Icons.account_circle_rounded, size: 60, color: ColorSchemes.kingaGrey,)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${caregivers.elementAt(index).firstname} ${caregivers.elementAt(index).lastname}', style: const TextStyle(fontSize: 18)),
                                Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    padding: const EdgeInsets.all(4),
                                    decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ColorSchemes.kingaGrey))),
                                    child: Text(caregivers.elementAt(index).label, style: const TextStyle(fontSize: 15))
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (MapEntry phoneNumber in caregivers.elementAt(index).phoneNumbers.entries)
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(phoneNumber.key, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          decoration: const BoxDecoration(
                                            color: ColorSchemes.errorColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.phone_in_talk, color: Colors.white),
                                            onPressed: () async {
                                              Uri number = Uri.parse('tel:${phoneNumber.value}');
                                              await launchUrl(number);
                                            },),
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          )
                        ]
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(height: 1,),
                  itemCount: caregivers.length,
                  shrinkWrap: true,
                ),
              )
            ],
        ),
      ),
    );
  }
}
