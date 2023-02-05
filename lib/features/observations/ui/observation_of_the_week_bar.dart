import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/features/observations/ui/answer_observation_screen.dart';
import 'package:kinga/features/observations/ui/bloc/observation_of_the_week_bar_cubit.dart';

class ObservationOfTheWeekBar extends StatelessWidget {
  const ObservationOfTheWeekBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ObservationOfTheWeekBarCubit(),
      child: BlocBuilder<ObservationOfTheWeekBarCubit, ObservationOfTheWeekBarState>(
        builder: (context, state) {
          if (state is ObservationOfTheWeekBarInitial) {
            return Container();
          }
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AnswerObservationScreen(),));
            },
            child: Material(
              elevation: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    Row(children: [
                      /*
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Container(height: 50, width: 50, decoration: ShapeDecoration(color: ColorSchemes.kingaGrey, shape: CircleBorder()), child: Icon(Icons.auto_graph),),
                    Text("3 / 11"),
                  ],),
                ),

                 */
                      Expanded(
                        child: Column(children: [
                          Text("Frage der Woche:"),
                          Text('"${(state as ObservationOfTheWeekBarLoaded).question.text}"', style: const TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                      ),
                      /*
                      IconButton(icon: Icon(Icons.close), onPressed: () {

                      },),

                       */
                    ],),
                    // LinearProgressIndicator(value: 3.0 / 11.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
