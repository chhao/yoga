# Gemini Project Context: Yoga App

## Project Overview

This is a Flutter-based yoga application intended for both Android and iOS platforms. The app's core functionality is structured around three main tabs:

*   **体式 (Poses):**  For displaying yoga poses.
*   **练习 (Practice):** For guided yoga sequences.
*   **呼吸 (Breath):** For breathing exercises.

The project is in its initial development phase, with the basic navigation structure and asset integration in place.

## Building and Running

To get the application running, follow these steps:

1.  **Install Dependencies:** Ensure you have Flutter installed, then run the following command to fetch the project's dependencies:
    ```bash
    flutter pub get
    ```

2.  **Run the Application:** You can run the app on a connected device or simulator using:
    ```bash
    flutter run
    ```

3.  **Run Tests:** To execute the widget tests, use:
    ```bash
    flutter test
    ```

## Development Conventions

*   **Code Style:** The project adheres to the standard Dart and Flutter style guidelines enforced by the `flutter_lints` package, as configured in `analysis_options.yaml`.
*   **Architecture:** The application uses a `StatefulWidget` for the main screen (`MyHomePage`) to manage the state of the `BottomNavigationBar`. The content for each tab is encapsulated in its own `StatelessWidget`:
    *   `PosesScreen`
    *   `PracticeScreen`
    *   `BreathScreen`
*   **Assets:** All project assets are located in the `/assets` directory and are registered in `pubspec.yaml`. This includes:
    *   SVG icons in `assets/`
    *   Audio files in `assets/audio/`
    *   JSON data files in `assets/data/`
*   **Dependencies:** The project uses the `flutter_svg` package to render SVG images.
