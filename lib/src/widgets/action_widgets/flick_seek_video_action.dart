import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// GestureDetector's that calls [flickControlManager.seekForward]/[flickControlManager.seekBackward] onTap of opaque area/child.
///
/// Renders two GestureDetector inside a row, the first detector is responsible to seekBackward and the second detector is responsible to seekForward.
class FlickSeekVideoAction extends StatefulWidget {
  const FlickSeekVideoAction({
    Key? key,
    this.child,
    this.forwardSeekIcon = const Icon(Icons.fast_forward),
    this.backwardSeekIcon = const Icon(Icons.fast_rewind),
    this.duration = const Duration(seconds: 3),
    this.seekForward,
    this.seekBackward,
    this.handleVideoTap,
  }) : super(key: key);

  /// Widget to be stacked above this action.
  final Widget? child;

  /// Widget to be shown when user forwardSeek the video.
  ///
  /// This widget is shown for a duration managed by [FlickDisplayManager].
  final Widget forwardSeekIcon;

  /// Widget to be shown when user backwardSeek the video.
  ///
  /// This widget is shown for a duration managed by [FlickDisplayManager].
  final Widget backwardSeekIcon;

  /// Function called onTap of [forwardSeekIcon].
  ///
  /// Default action -
  /// ``` dart
  ///    controlManager.seekForward(Duration(seconds: 10));
  /// ```
  final Function? seekForward;

  /// Function called onTap of [backwardSeekIcon].
  ///
  /// Default action -
  /// ``` dart
  ///     controlManager.seekBackward(Duration(seconds: 10));
  /// ```
  final Function? seekBackward;

  /// Duration by which video will be seek.
  final Duration duration;

  /// Function called onTap of the opaque area/child.
  ///
  /// Default action -
  /// ``` dart
  ///    displayManager.handleVideoTap();
  /// ```
  final Function? handleVideoTap;

  @override
  State<StatefulWidget> createState() => _FlickSeekVideoActionState();
}

class _FlickSeekVideoActionState extends State<FlickSeekVideoAction> {
  Timer? timer;
  bool showBackwardSeek = false;
  bool showForwardSeek = false;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);

    // bool showForwardSeek = displayManager.showForwardSeek;
    // bool showBackwardSeek = displayManager.showBackwardSeek;

    return Stack(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (widget.handleVideoTap != null) {
                  widget.handleVideoTap!();
                } else {
                  displayManager.handleVideoTap();
                }
              },
              onTapDown: (detail) {
                if (timer != null) {
                  timer?.cancel();
                }
                timer =
                    Timer.periodic(const Duration(milliseconds: 500), (timer) {
                  if (!showBackwardSeek) {
                    setState(() {
                      showBackwardSeek = true;
                    });
                  }
                  if (widget.seekBackward != null) {
                    widget.seekBackward!();
                  } else {
                    controlManager.seekBackward(widget.duration);
                  }
                });
              },
              onTapUp: (detail) {
                if (timer != null) {
                  timer?.cancel();
                }
                if (showBackwardSeek) {
                  setState(() {
                    showBackwardSeek = false;
                  });
                }
              },
              onTapCancel: () {
                if (timer != null) {
                  timer?.cancel();
                }
                if (showBackwardSeek) {
                  setState(() {
                    showBackwardSeek = false;
                  });
                }
              },
              child: Align(
                alignment: Alignment.center,
                child: AnimatedCrossFade(
                  duration: Duration(milliseconds: 100),
                  firstChild: IconTheme(
                    data: IconThemeData(color: Colors.transparent),
                    child: widget.backwardSeekIcon,
                  ),
                  crossFadeState: showBackwardSeek
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  secondChild: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: widget.backwardSeekIcon,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (widget.handleVideoTap != null) {
                  widget.handleVideoTap!();
                } else {
                  displayManager.handleVideoTap();
                }
              },
              onTapDown: (detail) {
                if (timer != null) {
                  timer?.cancel();
                }
                timer =
                    Timer.periodic(const Duration(milliseconds: 500), (timer) {
                  if (!showForwardSeek) {
                    setState(() {
                      showForwardSeek = true;
                    });
                  }
                  if (widget.seekForward != null) {
                    widget.seekForward!();
                  } else {
                    controlManager.seekForward(widget.duration);
                  }
                });
              },
              onTapUp: (detail) {
                if (timer != null) {
                  timer?.cancel();
                }
                if (showForwardSeek) {
                  setState(() {
                    showForwardSeek = false;
                  });
                }
              },
              onTapCancel: () {
                if (timer != null) {
                  timer?.cancel();
                }
                if (showForwardSeek) {
                  setState(() {
                    showForwardSeek = false;
                  });
                }
              },
              child: Align(
                alignment: Alignment.center,
                child: AnimatedCrossFade(
                  duration: Duration(milliseconds: 100),
                  firstChild: IconTheme(
                      data: IconThemeData(
                        color: Colors.transparent,
                      ),
                      child: widget.forwardSeekIcon),
                  crossFadeState: showForwardSeek
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  secondChild: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: widget.forwardSeekIcon,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      if (widget.child != null) SizedBox(child: widget.child),
    ]);
  }
}
