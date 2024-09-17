import 'package:flutter/material.dart';
import '../../extensions/text_styles.dart';
import 'colors.dart';
import 'common.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/bool_extensions.dart';

import 'constants.dart';

/// Default App Button
class AppButton extends StatefulWidget {
  final Function? onTap;
  final String? text;
  final double? width;
  final Color? color;
  final Color? textColor;
  final Color? disabledColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  final ShapeBorder? shapeBorder;
  final Widget? child;
  final double? elevation;
  final double? height;
  final bool? enabled;
  final bool? enableScaleAnimation;

  AppButton({
    this.onTap,
    this.text,
    this.width,
    this.color,
    this.textColor,
    this.padding,
    this.margin,
    this.textStyle,
    this.shapeBorder,
    this.child,
    this.elevation,
    this.enabled,
    this.height,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.enableScaleAnimation,
    Key? key,
  }) : super(key: key);

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  AnimationController? _controller;

  @override
  void initState() {
    if (widget.enableScaleAnimation
        .validate(value: enableAppButtonScaleAnimationGlobal)) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: appButtonScaleAnimationDurationGlobal ?? 50,
        ),
        lowerBound: 0.0,
        upperBound: 0.1,
      )
        ..addListener(() {
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && widget.enabled.validate(value: true)) {
      _scale = 1 - _controller!.value;
    }

    if (widget.enableScaleAnimation
        .validate(value: enableAppButtonScaleAnimationGlobal)) {
      return Listener(
        onPointerDown: (details) {
          _controller?.forward();
        },
        onPointerUp: (details) {
          _controller?.reverse();
        },
        child: Transform.scale(
          scale: _scale,
          child: buildButton(),
        ),
      );
    } else {
      return buildButton();
    }
  }

  Widget buildButton() {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color ?? appButtonBackgroundColorGlobal,
          borderRadius: widget.shapeBorder is RoundedRectangleBorder
              ? (widget.shapeBorder as RoundedRectangleBorder).borderRadius
              : BorderRadius.circular(
              24.0),
        ),
        child: MaterialButton(
          onPressed: widget.enabled.validate(value: true)
              ? widget.onTap != null
              ? widget.onTap as void Function()?
              : null
              : null,
          // color: Colors.transparent,
          // elevation: 0,
          shape: widget.shapeBorder ?? defaultAppButtonShapeBorder,
          padding: widget.padding ?? dynamicAppButtonPadding(context),
          disabledColor: widget.disabledColor,
          focusColor: widget.focusColor,
          hoverColor: widget.hoverColor,
          splashColor: widget.splashColor,
          child: widget.child ??
              Text(
                widget.text.validate(),
                style: widget.textStyle ??
                    boldTextStyle(
                      color: widget.textColor ??
                          defaultAppButtonTextColorGlobal,
                    ),
              ),
        ),
      ),
    );
  }
}