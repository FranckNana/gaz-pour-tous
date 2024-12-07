# gazpourtous

Application gaz pour tous destinée à la gestion des GPL

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Générer models

```
flutter pub run build_runner build --delete-conflicting-outputs
```

## Générer splash screen

```
dart run flutter_native_splash:create
```

## Générer launcher icon

```
dart run flutter_launcher_icons:main
```

Veuillez changer l'adresse du backend dans le fichier apiConstants
Ex au lieu de localhost avoir 176.12.3.7:7000