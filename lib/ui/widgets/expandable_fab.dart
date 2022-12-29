import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
  super.key,
  this.initialOpen,
  required this.icon,
  required this.color,
  required this.distance,
  required this.children,
  });

  final bool? initialOpen;
  final Widget icon;
  final Color color;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => ExpandableFabState();
}

class ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  bool get open => _open;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: _open,
          child: GestureDetector(
            onTap: () => setState(() {
              toggle();
            }),
            child: Container(
                color: const Color.fromRGBO(5, 5, 5, 0.5),
                height: MediaQuery.of(context).size.height,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                  child: const Center(),
                )
            ),
          ),
        ),
        SizedBox.expand(
          child: Transform.translate(
            offset: const Offset(-20, -20),
            child: Stack(
              alignment: Alignment.bottomRight,
              clipBehavior: Clip.none,
              children: [
                _buildTapToCloseFab(),
                ..._buildExpandingActionButtons(),
                _buildTapToOpenFab(),
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).errorColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    const step = 70;
    for (var i = 0, distance = step;
    i < count;
    i++, distance += step) {
      children.add(
        _ExpandingActionButton(
          //directionInDegrees: angleInDegrees,
          //maxDistance: widget.distance,
          directionInDegrees: 90,
          maxDistance: distance.toDouble(),
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: toggle,
            //foregroundColor: Theme.of(context).,
            backgroundColor: Theme.of(context).errorColor,
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: child!,
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
  super.key,
  this.onPressed,
  required this.icon,
  required this.text,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          decoration: ShapeDecoration(color: const Color.fromARGB(150, 0, 0, 0), shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10))),
          //color: Color.fromARGB(50, 0, 0, 0),
          child: Text(text, style: const TextStyle(color: Colors.white),)
        ),
        Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          color: theme.colorScheme.error,
          elevation: 4.0,
          child: IconButton(
            onPressed: onPressed,
            icon: icon,
          ),
        )
      ]
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
  super.key,
  required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}