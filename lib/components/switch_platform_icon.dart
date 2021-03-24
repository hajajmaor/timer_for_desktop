import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SwitchPlatformIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPlatform = PlatformProvider.of(context)!.platform;
    final bool isCupertino = currentPlatform == TargetPlatform.macOS ||
        currentPlatform == TargetPlatform.iOS;
    return Tooltip(
      message: 'Change to ${isCupertino ? "Material" : "Cupertino"} platform',
      child: PlatformIconButton(
        icon: const Icon(Icons.track_changes),
        onPressed: () {
          if (isCupertino) {
            PlatformProvider.of(context)!.changeToMaterialPlatform();
          } else {
            PlatformProvider.of(context)!.changeToCupertinoPlatform();
          }
        },
      ),
    );
  }
}
