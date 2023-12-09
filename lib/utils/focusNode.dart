import 'package:flutter/material.dart';

class MyTextWidget extends StatefulWidget {
  const MyTextWidget({
    super.key,
    this.onChanged,
    this.fillColor = const Color.fromRGBO(250, 250, 250, 1),
    this.focusColor = const Color.fromRGBO(240, 240, 240, 1),
  });

  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final Color? focusColor;

  @override
  State<MyTextWidget> createState() => _MyTextWidgetState();
}

class _MyTextWidgetState extends State<MyTextWidget> {
  late FocusNode _myFocusNode;
  final ValueNotifier<bool> _myFocusNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _myFocusNode = FocusNode();
    _myFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _myFocusNode.removeListener(_onFocusChange);
    _myFocusNode.dispose();
    _myFocusNotifier.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    _myFocusNotifier.value = _myFocusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _myFocusNotifier,
      builder: (_, isFocus, child) {
        return TextField(
          focusNode: _myFocusNode,
          decoration: InputDecoration(
            filled: true,
            fillColor: isFocus ? widget.focusColor : widget.fillColor,
          ),
          onChanged: (value) => widget.onChanged,
        );
      },
    );
  }
}
