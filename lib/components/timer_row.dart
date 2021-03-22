import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:timer_for_desktop/constants.dart';

class TimerRow extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final BuildContext context;
  final double width;
  final void Function(String) onChanged;
  const TimerRow({
    Key? key,
    required this.controller,
    required this.text,
    required this.context,
    required this.width,
    required this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // color: Colors.green,
        padding: const EdgeInsets.all(5),
        height: width > 300 ? 65 : 110,
        width: 200,
        child: Flex(
          direction: width > 300 ? Axis.horizontal : Axis.vertical,
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PlatformText('$text:'),
            Expanded(
              child: Container(),
            ),
            SizedBox(
              width: 80,
              child: PlatformTextField(
                keyboardType: TextInputType.number,
                controller: controller,
                textAlign: TextAlign.center,
                onChanged: onChanged,
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(dRegExpNumbers),
                ],
                material: (context, platform) => MaterialTextFieldData(
                  decoration:
                      const InputDecoration(counterText: 'Numbers only'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
