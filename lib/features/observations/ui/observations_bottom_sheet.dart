import 'package:flutter/material.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';

class ObservationsBottomSheet extends StatelessWidget {
  ObservationsBottomSheet({Key? key}) : super(key: key);
  Map<String, String> observationSheets = {'Seldak': '13/42', 'Perik': '13/37'}; //TODO
  List<String> observations = ['Seldak', 'Perik'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: ColorSchemes.kingacolor,
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
                      Container(padding: const EdgeInsets.only(right: 15), child: const Icon(Icons.auto_graph)),
                      const Text(Strings.tabObservations, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: const [
                          Text(Strings.questionOfTheWeek),
                          Text("\"Kind bringt von sich aus eigene Beiträge ein\"", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),) // TODO: automatically selected
                        ],
                      ),
                    ),
                    const Divider(height: 10,),
                    ListView.builder(itemBuilder: (context, index) {
                      return IntrinsicHeight(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorSchemes.kingaGrey.withOpacity(0.3)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ColorSchemes.kingacolor))),
                                        child: Text(observations.elementAt(index))
                                    ),
                                    IntrinsicHeight(
                                      child: Column(
                                        children: [
                                          Text(observationSheets[observations.elementAt(index)] ?? ''),
                                          Text(Strings.questionsAnswered, style: TextStyle(color: Colors.black.withOpacity(0.4)),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: Row(
                                children: [
                                  const Spacer(),
                                  TextButton(child: const Text(Strings.getResults), onPressed: () {},),
                                ],
                              ))
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: observations.length,
                    shrinkWrap: true,
                    )
                  ],
                ),
              )
        ],
      ),
    )
    );
  }
}
