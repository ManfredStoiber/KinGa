import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/incidences/ui/bloc/incidences_cubit.dart';

import 'incidence_item.dart';

class ShowIncidencesWidget extends StatefulWidget {
  final String studentId;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final Function()? onIncidencesChanged;

  ShowIncidencesWidget(this.studentId, {Key? key, this.onIncidencesChanged}) : super(key: key);

  @override
  State<ShowIncidencesWidget> createState() => ShowIncidencesWidgetState();

}

class ShowIncidencesWidgetState extends State<ShowIncidencesWidget> {

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
          widget.listKey?.currentState?.removeItem(duration: changedFilter ? const Duration(milliseconds: 0) : const Duration(milliseconds: 500), previousIncidences.indexOf(incidence), (context, animation) {
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
          widget.listKey!.currentState!.insertItem(duration: changedFilter ? const Duration(milliseconds: 0) : const Duration(milliseconds: 250), newIncidences.indexOf(incidence));
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
          physics: const ClampingScrollPhysics(),
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
                          IntrinsicWidth(
                            child: Container(
                              decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: ColorSchemes.kingacolor, width: 0)), color: ColorSchemes.kingacolor),
                              child: DropdownButtonFormField<String>(
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
                          IntrinsicWidth(
                            child: Container(
                              decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: ColorSchemes.kingacolor, width: 0)), color: ColorSchemes.kingacolor),
                              child: DropdownButtonFormField<String>(
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
            AnimatedList(key: widget.listKey,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              initialItemCount: state.incidences.length,
              itemBuilder: (context, index, animation) {
                return AnimatedSlideMenu(key: UniqueKey(), animation: animation, index: index, listKey: widget.listKey, studentId: widget.studentId,);
            },),
            BlocBuilder<IncidencesCubit, IncidencesState>(
              builder: (context, state) {
                if (state is IncidencesLoaded && state.incidences.isNotEmpty) {
                  return Container();
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Container(margin: const EdgeInsets.all(20), width: 50, child: Opacity(opacity: 0.7, child: Image.asset('assets${Platform.pathSeparator}images${Platform.pathSeparator}no_results.png'))),
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
}

class AnimatedSlideMenu extends StatelessWidget {

  final GlobalKey<AnimatedListState>? listKey;
  final int index;
  final String studentId;
  final animation;
  final GlobalKey<SlideMenuState> slideMenuKey = GlobalKey();

  AnimatedSlideMenu({Key? key, required this.listKey, required this.index, required this.studentId, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
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
                      ColorSchemes.errorColor),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                  )
              ),
              onPressed: () {
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
                        .elementAt(index);
                    GetIt.I<StudentService>().deleteIncidence(studentId, incidenceToRemove).then((value) {
                    });
                  }
                });
              }, child: const Icon(Icons.delete)
          ),
        ),
      ],
          child: IncidenceItem(studentId, (BlocProvider.of<IncidencesCubit>(context).state as IncidencesLoaded).incidences.elementAt(index))
      ),
    );
  }
}


class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;
  final double? progress;

  const SlideMenu({Key? key,
    required this.child, required this.menuItems, this.progress
  }) : super(key: key);

  @override
  State<SlideMenu> createState() => SlideMenuState();
}

class SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Here the end field will determine the size of buttons which will appear after sliding
    //If you need to appear them at the beginning, you need to change to "+" Offset coordinates (0.2, 0.0)
    final animation = widget.progress == null ?
    Tween(begin: const Offset(0.0, 0.0),
        end: const Offset(-0.2, 0.0))
        .animate(CurveTween(curve: Curves.decelerate).animate(_controller)) :
    Tween(begin: Offset(-0.2 * widget.progress!, 0.0),
        end: Offset(-0.2 * widget.progress!, 0.0)).animate(_controller);

    return GestureDetector(
        onHorizontalDragUpdate: (data) {
          // we can access context.size here
          setState(() {
            //Here we set value of Animation controller depending on our finger move in horizontal axis
            //If you want to slide to the right, change "-" to "+"
            _controller.value -= (data.primaryDelta! / (context.size!.width*0.2));
          });
        },
        onHorizontalDragEnd: (data) {
          //To change slide direction, change to data.primaryVelocity! < -1500
          if (data.primaryVelocity! > 1500)
            _controller.animateTo(.0); //close menu on fast swipe in the right direction
          //To change slide direction, change to data.primaryVelocity! > 1500
          else if (_controller.value >= .5 || data.primaryVelocity! < -1500)
            _controller.animateTo(1.0); // fully open if dragged a lot to left or on fast swipe to left
          else // close if none of above
            _controller.animateTo(.0);
        },
        child: LayoutBuilder(builder: (context, constraint) {
          return Stack(
            children: [
              SlideTransition(
                position: animation,
                child: widget.child,
              ),
              AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    //To change slide direction to right, replace the right parameter with left:
                    return Positioned(
                      right: .0,
                      top: .0,
                      bottom: .0,
                      width: constraint.maxWidth * animation.value.dx * -1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: widget.menuItems.map((child) {
                          return Expanded(
                            child: child,
                          );
                        }).toList(),
                      ),
                    );
                  })
            ],
          );
        })
    );
  }
}