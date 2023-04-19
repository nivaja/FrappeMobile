import 'package:flutter/material.dart';

class FullScreenContainer extends StatefulWidget {
  final Widget child;

  FullScreenContainer({required this.child});

  @override
  _FullScreenContainerState createState() => _FullScreenContainerState();
}

class _FullScreenContainerState extends State<FullScreenContainer> {
  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isFullScreen)
          GestureDetector(
            onTap: () {
              setState(() {
                _isFullScreen = false;
              });
            },
            child: Container(
              color: Colors.black,
            ),
          ),
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: _isFullScreen ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: widget.child,
          ),
        ),
        if (!_isFullScreen)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isFullScreen = true;
                });
              },
              child: Icon(Icons.fullscreen),
            ),
          ),
      ],
    );
  }
}



