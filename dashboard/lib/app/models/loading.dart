import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Loading class
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: SpinKitRipple(
          color: Colors.white,
          size: 40.0,
        ),
      ),
    );
  }
}