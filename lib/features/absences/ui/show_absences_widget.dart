import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/features/absences/ui/bloc/absences_cubit.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:kinga/util/date_utils.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ShowAbsencesWidget extends StatefulWidget {
  const ShowAbsencesWidget(this.studentId, {Key? key}) : super(key: key);

  final String studentId;

  @override
  State<ShowAbsencesWidget> createState() => _ShowAbsencesWidgetState();
}

class _ShowAbsencesWidgetState extends State<ShowAbsencesWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AbsencesCubit(widget.studentId),
    child: BlocBuilder<AbsencesCubit, AbsencesState>(
      builder: (context, state) {
        if (state is AbsencesLoaded) {
          AbsencesCubit cubit = BlocProvider.of<AbsencesCubit>(context);
          if (state.selectedAbsences.value.isEmpty) {
            return Column(
              children: [
                Container(margin: const EdgeInsets.all(30), width: 100, child: SimpleShadow(child: Opacity(opacity: 0.4, child: Image.asset('assets/images/no_absences.png')))),
                Text(Strings.noAbsences, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
                Container(margin: const EdgeInsets.all(20), child: Text(Strings.noAbsencesDescription, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
              ],
            );
          } else {
            return ValueListenableBuilder<List<Absence>>(valueListenable: state.selectedAbsences, builder: (context, value, child) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: value.length,
              itemBuilder: (context, index) => Card(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IntrinsicWidth(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(text: IsoDateUtils.getGermanDateFromIsoDate(value.elementAt(index).from)),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabled: false,
                                labelText: Strings.start
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(text: IsoDateUtils.getGermanDateFromIsoDate(value.elementAt(index).until)),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabled: false,
                                labelText: Strings.end
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(text: value.elementAt(index).sickness ? "Krankmeldung" : "Urlaub"), // TODO
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabled: false,
                              labelText: Strings.reason,
                            ),
                          ),
                        ),
                        IconButton(onPressed: () {
                          showDialog(context: context, builder: (context) => AlertDialog(
                            title: const Text(Strings.removeAbsence),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.of(context).pop(false);
                              }, child: const Text(Strings.cancel)),
                              TextButton(onPressed: () {
                                Navigator.of(context).pop(true);
                              }, child: const Text(Strings.confirm)),
                            ],
                          ),).then((confirmed) {
                            if (confirmed ?? false) {
                              cubit.removeAbsence(widget.studentId, value.elementAt(index));
                            }
                          });
                        },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: ColorSchemes.errorColor,
                            ))
                      ],
                    ),
                  )
              ),
            ),);
          }
        } else {
          return const LoadingIndicator();
        }
      },
    )
    );
  }
}