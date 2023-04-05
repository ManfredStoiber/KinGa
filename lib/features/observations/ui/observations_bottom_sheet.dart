import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/features/observations/domain/observation_service.dart';
import 'package:kinga/features/observations/ui/bloc/observations_cubit.dart';
import 'package:kinga/features/observations/ui/observations_bottom_sheet.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';

class ObservationsBottomSheet extends StatelessWidget {

  ObservationsCubit cubit;

  ObservationsBottomSheet(this.cubit, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObservationsCubit, ObservationsState>(
      bloc: cubit,
  builder: (context, state) {
        if (state is ObservationsLoaded) {
          Map<String, List<int>> observationFormSummaries = {};
          for (var observation in state.observations) {
            var summary = observationFormSummaries[observation.question.observationForm.title] ?? [0, 0];
            summary[1]++;
            if (observation.answer != null) {
              summary[0]++;
            }
            observationFormSummaries[observation.question.observationForm.title] = summary;
          }
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
                          ListView.builder(
                            itemCount: observationFormSummaries.keys.sorted().length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              String observationFormTitle = observationFormSummaries.keys.sorted().elementAt(index);
                              List<int> summary = observationFormSummaries[observationFormTitle] ?? [0, 0];
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
                                              child: Text(observationFormSummaries.keys.sorted().elementAt(index))
                                          ),
                                          IntrinsicHeight(
                                            child: Column(
                                              children: [
                                                Text("${summary[0]}/${summary[1]}"),
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
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
          );
        } else if (state is ObservationsLoading) {
          return const LoadingIndicator();
        } else {
          return const Text("TODO"); // TODO
        }
  },
);
  }
}
