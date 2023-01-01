import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/incidences/ui/bloc/incidences_cubit.dart';
import 'package:kinga/features/incidences/ui/edit_incidence_dialog.dart';
import 'package:kinga/ui/widgets/slide_menu.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'incidence_item.dart';

class ShowIncidencesWidget extends StatefulWidget {
  final String studentId;
  final GlobalKey<AnimatedListState> listKey;
  final Function()? onIncidencesChanged;

  ShowIncidencesWidget(this.studentId, this.listKey, {Key? key, this.onIncidencesChanged}) : super(key: key);

  @override
  State<ShowIncidencesWidget> createState() => ShowIncidencesWidgetState();

}

class ShowIncidencesWidgetState extends State<ShowIncidencesWidget> with AutomaticKeepAliveClientMixin<ShowIncidencesWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => IncidencesCubit(widget.studentId),
  child: BlocConsumer<IncidencesCubit, IncidencesState>(
      listenWhen: (previous, current) {
        return previous is IncidencesLoaded && current is IncidencesLoaded;
      },
      listener: (context, state) {
        IncidencesCubit cubit = BlocProvider.of<IncidencesCubit>(context);

        bool changedFilter = (cubit.last as IncidencesLoaded).selectedTimeFrame != (state as IncidencesLoaded).selectedTimeFrame ||(cubit.last as IncidencesLoaded).selectedCategory != state.selectedCategory;
        List<Incidence> previousIncidences = (cubit.last as IncidencesLoaded).incidences.toList(); // copy list without reference to keep track of indices
        List<Incidence> newIncidences = state.incidences;

        // incidence(s) removed
        var removedIncidences = previousIncidences.where((incidence) => !newIncidences.contains(incidence)).toList();
        for (var incidence in removedIncidences) {
          widget.listKey.currentState?.removeItem(duration: changedFilter ? const Duration(milliseconds: 0) : const Duration(milliseconds: 500), previousIncidences.indexOf(incidence), (context, animation) {
            return changedFilter ? AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                var height = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: const Interval(0.0, 0.25)));
                return SizeTransition(
                  sizeFactor: animation.drive(height),
                  child: IncidenceItem(widget.studentId, incidence),
                  );
                },
              ) : AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                var slide = Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)).chain(CurveTween(curve: const Interval(0.25, 1.0)));
                var height = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: const Interval(0.0, 0.25)));
                return SizeTransition(
                  sizeFactor: animation.drive(height),
                  child: SlideTransition(position: animation.drive(slide), child: SlideMenu(progress: 0.0, menuItems: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      margin: Theme.of(context).cardTheme.margin,
                      child: ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(ColorSchemes.errorColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )
                              )
                          ),
                          onPressed: () {}, child: const Icon(Icons.delete)
                      ),
                    )
                  ] ,child: IncidenceItem(widget.studentId, incidence))),
                );
              },
            )
            ;
          }
          );
          previousIncidences.removeAt(previousIncidences.indexOf(incidence));
        }

        // new incidence(s) added
        var addedIncidences = newIncidences.where((incidence) => !previousIncidences.contains(incidence)).toList();
        for (var incidence in addedIncidences) {
          widget.listKey.currentState!.insertItem(duration: changedFilter ? const Duration(milliseconds: 0) : const Duration(milliseconds: 250), newIncidences.indexOf(incidence));
          previousIncidences.insert(newIncidences.indexOf(incidence), incidence); // insert to keep track of indices
        }

        // TODO: dynamically add shadow if enough items in list
        /*
        if ((removedIncidences.isNotEmpty || addedIncidences.isNotEmpty) && widget.onIncidencesChanged != null) {
          widget.onIncidencesChanged!();
        }
         */
      },
      buildWhen: (previous, current) => !(previous is IncidencesLoaded && current is IncidencesLoaded), // only build when not listen (otherwise AnimatedList would be rebuilt without showing animations)
      builder: (context, state) {
        return state is IncidencesLoaded ? ListView(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 30),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            BlocBuilder<IncidencesCubit, IncidencesState>(
              builder: (context, state2) {
                if (state2 is IncidencesLoaded) {
                  return Container(
                    padding: const EdgeInsets.all(15),
                    child: Theme(
                      data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (state.hasIncidences)
                            IntrinsicWidth(
                              child: Container(
                                decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: ColorSchemes.kingacolor, width: 0)), color: ColorSchemes.kingacolor),
                                child: DropdownButtonFormField<String>(
                                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                  decoration: InputDecoration (
                                    isDense: true,
                                    prefixIcon: Container(padding: const EdgeInsets.fromLTRB(10, 5, 5, 5), child: Icon(size: 20, Icons.category_outlined, color: Colors.black)),
                                    prefixIconConstraints: const BoxConstraints(maxHeight: 30),
                                    enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.transparent)),
                                    contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5)
                                  ),
                                  alignment: Alignment.center,
                                  value: state2.selectedCategory,
                                  items: const [
                                    DropdownMenuItem( value: Strings.all, child: Text(Strings.all)),
                                    DropdownMenuItem(value: Strings.achievement, child: Text(Strings.achievement)),
                                    DropdownMenuItem( value: Strings.accident, child: Text(Strings.accident)),
                                    DropdownMenuItem( value: Strings.other, child: Text(Strings.other))
                                  ],
                                  onChanged: (String? newValue) {
                                    BlocProvider.of<IncidencesCubit>(context)
                                        .onSelectedCategoryChanged(newValue);
                                  },
                                ),
                              ),
                            ),
                          state.hasIncidences ?
                            IntrinsicWidth(
                              child: Container(
                                decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: ColorSchemes.kingacolor, width: 0)), color: ColorSchemes.kingacolor),
                                child: DropdownButtonFormField<String>(
                                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                  decoration: InputDecoration (
                                      isDense: true,
                                      prefixIcon: Container(padding: const EdgeInsets.fromLTRB(10, 5, 5, 5), child: Icon(size: 20, Icons.calendar_today, color: Colors.black)),
                                      prefixIconConstraints: const BoxConstraints(maxHeight: 30),
                                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                      border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                      contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5)
                                  ),
                                  alignment: Alignment.center,
                                  value: state2.selectedTimeFrame,
                                  items: const [
                                    DropdownMenuItem( value: Strings.today, child: Text(Strings.today)),
                                    DropdownMenuItem(value: Strings.lastMonth, child: Text(Strings.lastMonth)),
                                    DropdownMenuItem( value: Strings.lastYear, child: Text(Strings.lastYear)),
                                    DropdownMenuItem( value: Strings.all, child: Text(Strings.all))
                                  ],
                                  onChanged: (String? newValue) {
                                    BlocProvider.of<IncidencesCubit>(context)
                                        .onSelectedTimeFrameChanged(newValue);
                                  },
                                ),
                              ),
                            ) :
                            Center(
                              child: Column(
                                children: [
                                  Container(margin: const EdgeInsets.all(20), width: 100, child: SimpleShadow(child: Opacity(opacity: 0.4, child: Image.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}no_results.png')),),),
                                  const Text(Strings.noIncidences, style: TextStyle(color: ColorSchemes.textColorLight),),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Text("TODO"); // TODO
                }

              },
            ),
            Container(
              child: AnimatedList(key: widget.listKey,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                initialItemCount: state.incidences.length,
                itemBuilder: (context, index, animation) {
                  return AnimatedSlideMenu(key: UniqueKey(), animation: animation, index: index, listKey: widget.listKey, studentId: widget.studentId,);
              },),
            ),
            BlocBuilder<IncidencesCubit, IncidencesState>(
              builder: (context, state) {
                if (state is IncidencesLoaded && state.incidences.isNotEmpty || state is IncidencesLoaded && !state.hasIncidences) {
                  return Container();
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          width: 50,
                          child: SimpleShadow(
                            child: Opacity(
                                opacity: 0.4,
                                child: Image.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}no_results.png')
                            ),
                          ),
                        ),
                        const Text(Strings.noIncidences, style: TextStyle(color: ColorSchemes.textColorLight),),
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ) : const Text("TODO"); // TODO
      }
    )
);
  }

  @override
  bool get wantKeepAlive => true;
}

class AnimatedSlideMenu extends StatefulWidget {

  final GlobalKey<AnimatedListState>? listKey;
  final int index;
  final String studentId;
  final animation;

  AnimatedSlideMenu({Key? key, required this.listKey, required this.index, required this.studentId, required this.animation}) : super(key: key);

  @override
  State<AnimatedSlideMenu> createState() => _AnimatedSlideMenuState();
}

class _AnimatedSlideMenuState extends State<AnimatedSlideMenu> with AutomaticKeepAliveClientMixin {
  final GlobalKey<SlideMenuState> slideMenuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      child: SlideMenu(menuItems: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
          margin: Theme
              .of(context)
              .cardTheme
              .margin,
          child: ElevatedButton(
              clipBehavior: Clip.antiAlias,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      ColorSchemes.kingacolor),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                  )
              ),
              onLongPress: onEdit,
              onPressed: onEdit,
              child: const Icon(Icons.edit)
          ),
        ),Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
          margin: Theme
              .of(context)
              .cardTheme
              .margin,
          child: ElevatedButton(
              clipBehavior: Clip.antiAlias,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      ColorSchemes.errorColor),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                  )
              ),
              onLongPress: onDelete,
              onPressed: onDelete,
              child: const Icon(Icons.delete)
          ),
        ),
      ],
          child: IncidenceItem(widget.studentId, (BlocProvider.of<IncidencesCubit>(context).state as IncidencesLoaded).incidences.elementAt(widget.index))
      ),
    );
  }

  void onEdit() {
    Incidence incidenceToEdit = (BlocProvider.of<IncidencesCubit>(context).state as IncidencesLoaded).incidences
        .elementAt(widget.index);
    showDialog(context: context, builder: (context) => EditIncidenceDialog(widget.studentId, incidenceToEdit));
  }

  void onDelete() {
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          title: const Text(Strings.confirmDeleteIncidence),
          actions: [
            TextButton(onPressed: () =>
                Navigator.of(context).pop(false),
                child: const Text(Strings.cancel)),
            TextButton(onPressed: () =>
                Navigator.of(context).pop(true),
                child: const Text(Strings.confirm))
          ],
        ),).then((confirmed) {
      if (confirmed ?? false) {
        Incidence incidenceToRemove = (BlocProvider.of<IncidencesCubit>(context).state as IncidencesLoaded).incidences
            .elementAt(widget.index);
        GetIt.I<StudentService>().deleteIncidence(widget.studentId, incidenceToRemove).then((value) {
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

