
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math' as math;

class CompassButton extends StatefulWidget {
  final MapController mapController;
  final Function()? onPressed;

  const CompassButton({Key? key, required this.mapController, this.onPressed}) : super(key: key);

  @override
  _CompassButtonState createState() => _CompassButtonState();
}

class _CompassButtonState extends State<CompassButton> {
  double _mapRotation = 0;

  @override
  void initState() {
    super.initState();
    widget.mapController.mapEventStream.listen((event) {
      setState(() {
        _mapRotation = event.camera.rotation;
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
        onPressed: widget.onPressed ?? _resetRotation,
        backgroundColor: Colors.white,
        child: Transform.rotate(
          angle: _mapRotation * (math.pi / 180),
          child: SvgPicture.asset('assets/compass_icon.svg', width: 33, height: 33),
        ),
      ),
    );
  }

  void _resetRotation() {
    widget.mapController.rotate(0);
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_compass/flutter_compass.dart';
// import 'dart:math' as math;
// import 'package:flutter_svg/flutter_svg.dart';

// class CompassButton extends StatefulWidget {
//   final Function()? onPressed;

//   const CompassButton({Key? key, this.onPressed}) : super(key: key);

//   @override
//   _CompassButtonState createState() => _CompassButtonState();
// }

// class _CompassButtonState extends State<CompassButton> {
//   double? _heading = 0;

//   @override
//   void initState() {
//     super.initState();
//     FlutterCompass.events!.listen((event) {
//       setState(() {
//         _heading = event.heading;
        
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       width: 50,
//       child: FloatingActionButton(
//         elevation: 2,
//         shape: CircleBorder(),
//         onPressed: widget.onPressed,
//         backgroundColor: Colors.white,
//         child: Transform.rotate(angle: -_heading! * (math.pi / 180),
//           child: SvgPicture.asset('assets/compass_icon.svg', width: 33, height: 33),
//         ),
//       ),
//     );
//   }
// }
