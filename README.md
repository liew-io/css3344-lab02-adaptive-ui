# CSS3344 Lab 02 - Adaptive Student Profile

A standalone coursework project for CSS3344 Lab 02, built by extending the student profile card introduced in Lab 01. It keeps the Material profile card structure (student name, ID, and personal goal) and adds reusable sections, an adaptive portrait/landscape layout, and Material/Cupertino date and role pickers. This coursework is separate from the FYP.

## Features

- Lab 01 student profile card with student name, ID, and personal life goal.
- `OrientationBuilder` and available width adapt the profile and controls for portrait and landscape screens.
- Material date dialog and Cupertino date picker sheet.
- Material role dropdown and Cupertino role wheel picker.
- Local system date/time in the app bar for the lab screenshot requirement.

## Run

```sh
flutter pub get
flutter run
```

For a browser preview:

```sh
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8765
```

