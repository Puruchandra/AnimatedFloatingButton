import 'package:flutter/material.dart';
import 'dart:math' as maths;
import 'package:vector_math/vector_math.dart' show radians;

class AnimatedNavBar extends StatefulWidget {
  @override
  _AnimatedNavBarState createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: SizedBox.expand(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: RotateFloatingWidget(
        controller: animationController,
      ),
    ));
  }
}

class RotateFloatingWidget extends StatefulWidget {
  Animation<double> scale;
  Animation<double> translate;
  final AnimationController controller;
  RotateFloatingWidget({this.controller}) {
    scale = Tween<double>(begin: 1, end: 0.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    translate = Tween<double>(begin: 0, end: 80).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut));
  }

  @override
  _RotateFloatingWidgetState createState() => _RotateFloatingWidgetState();
}

class _RotateFloatingWidgetState extends State<RotateFloatingWidget> {
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (BuildContext context, Widget child) => Wrap(
          children: <Widget>[
            Stack(
              children: <Widget>[
                _buildRadialBtn(-45.0,
                    icon: Icons.file_download, color: Color(0xff7F66FF)),
                _buildRadialBtn(-90.0,
                    icon: Icons.save, color: Color(0xff7F66FF)),
                _buildRadialBtn(-135.0,
                    icon: Icons.camera_alt, color: Color(0xff7F66FF)),
                Transform.scale(
                  scale: (widget.scale.value) - 1,
                  child: FloatingActionButton(
                    backgroundColor: Color(0xff7F66FF),
                    onPressed: () {
                      widget.controller.reverse();
                    },
                    child: Icon(Icons.clear),
                  ),
                ),
                Transform.scale(
                  scale: widget.scale.value,
                  child: FloatingActionButton(
                    backgroundColor: Color(0xff7F66FF),
                    onPressed: () {
                      widget.controller.forward();
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
            // FloatingActionButton(
            //   child: Icon(Icons.ac_unit),
            //   onPressed: () {
            //     widget.controller.reverse();
            //   },
            // )
          ],
        ),
      ),
    );
  }

  _buildRadialBtn(double angle, {IconData icon, Color color}) {
    double rad = radians(angle);

    return Transform(
      transform: Matrix4.identity()
        ..translate(
          widget.translate.value * maths.cos(rad),
          widget.translate.value * maths.sin(rad),
        ),
      child: FloatingActionButton(
        backgroundColor: color,
        mini: true,
        child: Icon(
          icon,
        ),
      ),
    );
  }
}
