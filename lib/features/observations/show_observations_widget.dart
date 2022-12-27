import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/features/observations/show_observations_widget.dart';
import 'package:kinga/features/observations/ui/bloc/observations_cubit.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ShowObservationsWidget extends StatefulWidget {
  const ShowObservationsWidget(this.studentId, {Key? key}) : super(key: key);

  final String studentId;

  @override
  State<ShowObservationsWidget> createState() => _ShowObservationsWidgetState();
}

class _ShowObservationsWidgetState extends State<ShowObservationsWidget> with AutomaticKeepAliveClientMixin<ShowObservationsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ObservationsCubit(widget.studentId),
        child: BlocBuilder<ObservationsCubit, ObservationsState>(
          builder: (context, state) {
            if (state is ObservationsLoaded) {
              ObservationsCubit cubit = BlocProvider.of<ObservationsCubit>(context);
              return Column(
                children: [
                  Container(margin: const EdgeInsets.all(30), width: 100, child: SimpleShadow(child: Opacity(opacity: 0.4, child: Image.asset('assets/images/observations.png')))),
                  // TODO
                  Text('Frage des Tages:\n\"Kind bringt von sich aus eigene Beiträge ein\"', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
                  Container(margin: const EdgeInsets.all(20), child: Text('13/42 Fragen beantwortet', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
                ],
              );
            } else {
              return Column(
                children: [
                  const LoadingIndicator(),
                ],
              );
            }
          },
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
