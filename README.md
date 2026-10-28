# Lab 02 - Adaptive Profile

A standalone coursework project for CSS3344 Lab 02, separate from the FYP. It implements reusable layout sections, adaptive portrait/landscape composition, and four Material/Cupertino picker interactions.

## Features

- Reusable student details, destination title, actions, and description sections.
- `OrientationBuilder` switches between a vertically stacked portrait layout and a side-by-side landscape layout.
- Material date dialog and Cupertino date sheet.
- Material role dropdown and Cupertino role wheel picker.
- Custom painted alpine lake artwork; no third-party runtime packages or image downloads.
- A local system date/time label is visible in the app bar for the lab screenshot requirement.

## Run

```sh
flutter pub get
flutter run
```

For a browser preview:

```sh
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8765
```

The original Lab 01 project was not present in the supplied workspace, so this solution is a self-contained Flutter project based on the Lab 02 tutorial.
