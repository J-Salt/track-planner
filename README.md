# Track Planner

A new Flutter project.

# How to develop
## Setup
- Clone the repo into VSCode
- run `flutter doctor`
- Follow any steps to get all green checks
    - Typically this requires installing android studio.
    - By installing Android studio you will have access to an Android emulator for testing.
        - I use Pixel 3 on v. 34
    - You will also likely have to set your `ANDROID_HOME` environment variable.
    - Lastly, you will need to go to the SDK manager in AS and install the latest cmdline-tools
- After `flutter doctor` shows all green checks, run `flutter pub get` to download dependencies.
- After this you should be able to run the app with `flutter run`.

- ### Note:
    -You might have to have your own firebase_options after I add your account to the project. I'm not sure yet.

## When Contributing
- Open Android Studio and from the Select Project page, click the 3 dots to access AVD manager.
- Run your emulator.
- You can close the other AS windows here.
- In VSCode, from the command palette, select `Flutter: Select Device` and chose your emulator.
- Now when you run `flutter run` it should run on the emulator.

## General Tips
- Ignore Stateful widgets; I don't understand them and don't want to. There is a package to make states easier to manage

## Data Model
These are in progress and might not be perfect.

### User
- id
- username
- email
- activitiesId (to link to collection of activites)
- eventGroup
- type (c or a, coach or athlete)

### Activity
- id
- title
- desc
- setsId (collection of sets entities, a set is i.e. 4x100m w/ 2 mins rest, contains warmup, working sets, and cooldown)
- type (type of workout, track, lift?, road?)

### Set
- id
- isSingularDistance (bool to indicate if the collection of reps are all of the same distance, i.e. not a ladder workout. This will help in the summary page when decided whether to show 4x100 vs 100,200,300,400)
- reps (collection of reps, each rep has time and distance)

### Rep
- id
- distance (m)
- restTime
- paceTime (goal time for rep)
- isCompleted


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
