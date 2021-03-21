import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SwitchPlatformIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformIconButton(
        icon: const Icon(Icons.track_changes),
        onPressed: () {
          final currentPlatform = PlatformProvider.of(context)!.platform;
          if (currentPlatform == TargetPlatform.macOS ||
              currentPlatform == TargetPlatform.iOS) {
            PlatformProvider.of(context)!.changeToMaterialPlatform();
          } else {
            PlatformProvider.of(context)!.changeToCupertinoPlatform();
          }
        },
      );
}
