import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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
  bool isExtended = false;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _controller.addListener(() {
      if (_controller.value == 1.0) {
        setState(() {
          isExtended = true;
        });
      } else if (_controller.value == .0) {
        setState(() {
          isExtended = false;
        });
      }
    });
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
        end: Offset(-0.2 * widget.menuItems.length, 0.0))
        .animate(CurveTween(curve: Curves.decelerate).animate(_controller)) :
    Tween(begin: Offset(-0.2 * widget.progress!, 0.0),
        end: Offset(-0.2 * widget.menuItems.length * widget.progress!, 0.0)).animate(_controller);

    return GestureDetector(
        onHorizontalDragUpdate: isExtended ? (data) {
          // we can access context.size here
          setState(() {
            //Here we set value of Animation controller depending on our finger move in horizontal axis
            //If you want to slide to the right, change "-" to "+"
            _controller.value -= (data.primaryDelta! / (context.size!.width*0.2 * widget.menuItems.length));
          });
        } : null,
        onHorizontalDragEnd: isExtended ? (data) {
          //To change slide direction, change to data.primaryVelocity! < -1500
          if (data.primaryVelocity! > 1500) {
            _controller.animateTo(.0); //close menu on fast swipe in the right direction
          } else if (_controller.value >= .5 || data.primaryVelocity! < -1500) {
            _controller.animateTo(1.0); // fully open if dragged a lot to left or on fast swipe to left
          } else {
            _controller.animateTo(.0);
          }
        } : null,
        onTap: isExtended ? () {
          _controller.animateTo(.0);
        } : null,
        onLongPress: () {
          HapticFeedback.vibrate();
          _controller.value == .0 ? _controller.animateTo(1.0) : _controller.animateTo(.0);
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
