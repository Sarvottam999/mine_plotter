import 'package:flutter/material.dart';

class CustomGradientRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;
  
  const CustomGradientRangeSlider({
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${values.start.round()}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Zoom Range',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${values.end.round()}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: SliderTheme(
              

              data: SliderThemeData(
                rangeThumbShape: RoundRangeSliderThumbShape(
                  enabledThumbRadius: 8,
                ),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                // rangeTrackShape: GradientRangeSliderTrackShape(
                //   gradient: LinearGradient(
                //     colors: [Colors.blue, Colors.purple],
                //   ),
                // ),
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
              ),
              child: RangeSlider(
                 

                values: values,
                min: 1,
                max: 19,
                divisions: 18,
                labels: RangeLabels(
                  values.start.round().toString(),
                  values.end.round().toString(),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// // Custom track shape for gradient
// class GradientRangeSliderTrackShape extends RangeSliderTrackShape {
//   final Gradient gradient;

//   GradientRangeSliderTrackShape({required this.gradient});

//   // @override
//   // void paint(PaintingContext context, Offset offset, {
//   //   required RenderBox parentBox,
//   //   required SliderThemeData sliderTheme,
//   //   required Animation<double> enableAnimation,
//   //   required Offset startThumbCenter,
//   //   required Offset endThumbCenter,
//   //   bool isEnabled = true,
//   //   bool isDiscrete = true,
//   // }) {
//   //   final Canvas canvas = context.canvas;
//   //   final Paint paint = Paint()
//   //     ..shader = gradient.createShader(Rect.fromLTRB(
//   //       startThumbCenter.dx,
//   //       offset.dy,
//   //       endThumbCenter.dx,
//   //       offset.dy + parentBox.size.height,
//   //     ));

//   //   final Rect trackRect = Rect.fromLTRB(
//   //     startThumbCenter.dx,
//   //     offset.dy + (parentBox.size.height - 16) / 2,
//   //     endThumbCenter.dx,
//   //     offset.dy + (parentBox.size.height + 16) / 2,
//   //   );

//   //   canvas.drawRRect(
//   //     RRect.fromRectAndRadius(trackRect, Radius.circular(8)),
//   //     paint,
//   //   );
//   // }
  
//   @override
//   Rect getPreferredRect(PaintingContext context, Offset offset,{required RenderBox parentBox, required SliderThemeData sliderTheme, bool isEnabled = false, bool isDiscrete = false}) {
//     // TODO: implement getPreferredRect
//      final Canvas canvas = context.canvas;
//     final Paint paint = Paint()
//       ..shader = gradient.createShader(Rect.fromLTRB(
//         startThumbCenter.dx,
//         offset.dy,
//         endThumbCenter.dx,
//         offset.dy + parentBox.size.height,
//       ));

//     final Rect trackRect = Rect.fromLTRB(
//       startThumbCenter.dx,
//       offset.dy + (parentBox.size.height - 16) / 2,
//       endThumbCenter.dx,
//       offset.dy + (parentBox.size.height + 16) / 2,
//     );

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(trackRect, Radius.circular(8)),
//       paint,
//     ); 
//   }
// }

 