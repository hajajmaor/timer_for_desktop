# timer_for_desktop

A timer application for desktop, made with Flutter.

## Screenshots

### Home Screen:

<div style='height:300px'>

<img src="assets\screenshots\windows_material.jpg" width="45%">
<img src="assets\screenshots\windows_cupertino.jpg" width="45%">
    
</div>
    
### One Timer:

<div>

<img src="assets\screenshots\windows_material_oneTimer.jpg" width="45%">
<img src="assets\screenshots\windows_cupertino_oneTimer.jpg" width="45%">

</div>

### Try to add another blank timer:

<div>

<img src="assets\screenshots\windows_material_attempt.jpg" width="45%">
<img src="assets\screenshots\windows_cupertino_attempt.jpg" width="45%">

</div>

### Alert - timer is done:

<div>

<img src="assets\screenshots\windows_material_alert.jpg" width="45%">
<img src="assets\screenshots\windows_cupertino_alert.jpg" width="45%">

</div>

<hr>

## Getting Started

1.  Clone it:

    ```
    git clone https://github.com/hajajmaor/timer_for_desktop
    ```

2.  (`Optional`) Clone dirkbo/flutter_launcher_icons:

    - Clone only if you intent to change the application's icon.

      ```
      cd ../
      git clone https://github.com/dirkbo/flutter_launcher_icons
      ```

    - Then head for `pubspec.yaml` and uncomment lines `40-53`

      ```
      dev_dependencies:

      # flutter_launcher_icons:
      # path: ../flutter_launcher_icons
      # # repo : https://github.com/dirkbo/flutter_launcher_icons
      # # by the time of writing the PR is yet to me merged
      # flutter_icons:
      #   android: false
      #   ios: false
      #   macos: true
      #   windows: true
      #   # linux: true
      #   image_path: "assets/icon.png"
      #   # run with:
      #   # flutter pub run flutter_launcher_icons:main

      ```

    - Then change the path of `image_path:` to your image and run:

    ```

    flutter pub run flutter_launcher_icons:main

    ```

3.  Run and enjoy
    ```
    flutter run -d <device>
    ```

<hr>

## Fork it, add issues, add PRs, basicly ENJOY!!
