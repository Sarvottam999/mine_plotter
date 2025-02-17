import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';

class CompassButton extends StatefulWidget {
  final Function()? onPressed;

  const CompassButton({Key? key, this.onPressed}) : super(key: key);

  @override
  _CompassButtonState createState() => _CompassButtonState();
}

class _CompassButtonState extends State<CompassButton> {
  double? _heading = 0;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events!.listen((event) {
      setState(() {
        // _heading = event.heading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        elevation: 2,
      
        shape: CircleBorder(),
        onPressed: widget.onPressed,
        backgroundColor: Colors.white,
        child: Transform.rotate(angle: -_heading! * (math.pi / 180), // Adjust if needed
          child: SvgPicture.asset('assets/compass_icon.svg', width: 33, height: 33),
        ),
      ),
    );
  }
}
