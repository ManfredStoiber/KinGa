import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedTabBar extends StatefulWidget {
  const AnimatedTabBar(
      {super.key, required this.tabs, required this.controller});
  final List<Tab> tabs;
  final TabController controller;

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBar();
}

class _AnimatedTabBar extends State<AnimatedTabBar> {
  final animationCurve = Curves.easeInOut;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      tabIndex = widget.controller.index;
    });
    widget.controller.addListener(() {
      if (widget.controller.indexIsChanging) {
        setState(() {
          tabIndex = widget.controller.index;
        });
      }
    });
  }

  final tabHeight = 60.0;
  @override
  Widget build(BuildContext context) {
    var testKey = GlobalKey();
    return Container(
      color: Colors.transparent,
      height: tabHeight,
      padding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              return Container(
                /*
                padding: EdgeInsets.symmetric(horizontal: (){
                  var s = (constraints.maxWidth - (widget.tabs.length * 50)) / (widget.tabs.length + 1);
                  return s/2;
                }()),

                 */
                child: AlignTransition(alignment: Tween(begin: const Alignment(-1, 0), end: Alignment(- 1 / (widget.tabs.length - 1), 0)).animate(widget.controller.animation!), child: Container(
                  height: tabHeight,
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.only(top: 20.0),
                    width: (){
                      var s = (constraints.maxWidth - (widget.tabs.length * 50)) / (widget.tabs.length + 1);
                      return 50 + 2*s;
                    }(),
                    child: Stack(
                        alignment: Alignment.center,
                        children: (){
                          var children = <Widget>[];
                          for (var i = 0; i < widget.tabs.length; i++) {
                            children.add(FadeTransition(
                                opacity: Tween(begin: 0.0, end: 1.0).animate(ShiftingAnimation(widget.controller, i)),
                                child: Text(textAlign: TextAlign.center, '${widget.tabs[i].text}', style: const TextStyle(fontSize: 12)))
                            );
                          }
                          return children;
                        }()
                      //children: widget.tabs.map((tab) => ).toList()
                      /*
                        children: [
                          Text(
                            '${widget.tabs[tabIndex].text}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],

     */
                    ),
                  ),
                )),
              );
            }
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.tabs.asMap().entries.map((entry) {
              final i = entry.key;
              final tab = entry.value;
              return GestureDetector(
                onTap: () => widget.controller.animateTo(i),
                child: Container(
                  key: i == 0 ? testKey : GlobalKey(),
                  width: 50,
                    color: Colors.transparent,
                    height: tabHeight,
                    child: FadeTransition(
                      opacity: Tween(begin: .25, end: 1.0).animate(ShiftingAnimation(widget.controller, i)),
                      child: SlideTransition(position: Tween(begin: const Offset(0, 0), end: const Offset(0, -0.15)).animate(ShiftingAnimation(widget.controller, i)),
                          child: tab.icon ?? const Icon(CupertinoIcons.home)),
                      ),
                ),
              );
            }).toList()),
        ],
      ),
    );
  }
}

class ShiftingAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  ShiftingAnimation(this.controller, this.index);

  final TabController? controller;
  final int index;

  @override
  Animation<double> get parent => controller!.animation!;

  @override
  double get value => _indexChangeProgress(controller!, index);
}

/// I'm not exactly sure that what I did here. LOL
/// But the basic idea of this function is converting the value of controller
/// animation (witch is a double between 0.0 and number of tab items minus one)
/// to a double between 0.0 and 1.0 base on [index] of tab.
double _indexChangeProgress(TabController controller, int index) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  /// I created this part base on some experiments and I'm pretty sure this can be
  /// simplified!

  if (index != currentIndex && index != previousIndex) {
    if (controller.indexIsChanging) {
      return 0.0;
    } else if (controller.offset < 0 && index == controller.index - 1) {
      return controller.offset.abs().clamp(0.0, 1.0);
    } else if (controller.offset > 0 && index == controller.index + 1) {
      return controller.offset.abs().clamp(0.0, 1.0);
    } else {
      return 0.0;
    }
  }

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging) {
    if (index == currentIndex) {
      return 1.0 - controller.offset.abs().clamp(0.0, 1.0);
    } else {
      return (controller.index + 1 == previousIndex && controller.offset > 0) ||
          (controller.index - 1 == previousIndex && controller.offset < 0)
          ? controller.offset.abs().clamp(0.0, 1.0)
          : 0.0;
    }
  }

  // The TabController animation's value is changing from previousIndex to currentIndex.
  final double val = (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
  return index == currentIndex ? 1.0 - val : val;
}
