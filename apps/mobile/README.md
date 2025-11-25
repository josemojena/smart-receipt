# Smart Receipt Mobile App

Flutter mobile application for Smart Receipt - Expense tracking and receipt management for Android and iOS.

## Platforms

- ✅ Android
- ✅ iOS
- ❌ macOS (not supported)
- ❌ Web (not supported)

## Prerequisites

- **Flutter SDK** (latest stable version)
  - Install from [flutter.dev](https://docs.flutter.dev/get-started/install)
  - Verify installation: `flutter doctor`
- **Android Studio** / **Xcode** (for iOS development)
- **Android SDK** / **Xcode Command Line Tools**
- **Melos** (for monorepo management)
  - Install globally: `dart pub global activate melos`
  - Verify: `melos --version`

## Setup

### Initial Setup

1. **Navigate to the mobile app directory:**
   ```bash
   cd apps/mobile
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

   Or using Melos:
   ```bash
   melos get
   ```

3. **Verify Flutter setup:**
   ```bash
   flutter doctor
   ```

4. **Bootstrap Melos workspace (if needed):**
   ```bash
   melos bootstrap
   ```

### From Monorepo Root

You can also use the npm scripts from the root:

```bash
# Install dependencies
pnpm melos:get

# Run development
pnpm mobile:dev

# Build
pnpm mobile:build:android
pnpm mobile:build:ios

# Test and analyze
pnpm mobile:test
pnpm mobile:analyze
```

## Tech Stack

### State Management: BLoC

This project uses the **BLoC (Business Logic Component)** pattern for state management:

- **flutter_bloc**: ^9.1.1 - Flutter-specific BLoC implementation
- **bloc**: ^9.1.0 - Core BLoC library
- **bloc_test**: ^10.0.0 - Testing utilities for BLoC

### Monorepo Management: Melos

**Melos** is configured for managing the Flutter/Dart packages in this monorepo:

- Configuration: `melos.yaml`
- Scripts available for common tasks
- Ready for future multi-package Flutter setup

### Code Generation Tools

This project uses several code generation tools to reduce boilerplate:

- **build_runner**: ^2.10.4 - Tool for running code generators
- **freezed**: ^3.2.3 - Code generation for immutable classes and unions
- **json_serializable**: ^6.11.2 - JSON serialization code generation
- **flutter_gen_runner**: ^5.12.0 - Asset and resource code generation
- **flutter_native_splash**: ^2.4.7 - Native splash screen generation
- **flutter_flavorizr**: ^2.4.1 - App flavors configuration (dev/staging/prod)
- **very_good_analysis**: ^10.0.0 - Enhanced linting rules (replaces flutter_lints)

## Development

### Run on Android

```bash
# List available devices
flutter devices

# Run on connected Android device or emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Or from root
pnpm mobile:dev
```

### Run on iOS

```bash
# Run on iOS Simulator
flutter run

# Run on specific iOS device
flutter run -d <device-id>

# Or from root
pnpm mobile:dev
```

### Build

```bash
# Build Android APK
flutter build apk

# Build Android App Bundle (for Play Store)
flutter build appbundle

# Build iOS (requires macOS and Xcode)
flutter build ios

# Or from root
pnpm mobile:build:android
pnpm mobile:build:ios
```

## Melos Commands

Melos provides convenient scripts for managing the Flutter project. Run these from `apps/mobile/`:

```bash
# Install dependencies
melos get
# or: pnpm melos:get

# Analyze code
melos analyze
# or: pnpm melos:analyze

# Run tests
melos test
# or: pnpm melos:test

# Clean build files
melos clean
# or: pnpm melos:clean

# Format code
melos format
# or: pnpm melos:format

# Bootstrap workspace
melos bootstrap
# or: pnpm melos:bootstrap

# Generate code (build_runner)
melos build:runner
# or: pnpm melos:build:runner

# Watch for changes and generate code
melos watch:runner
# or: pnpm melos:watch:runner
```

## Code Generation

### Build Runner

This project uses `build_runner` to generate code for:
- **Freezed**: Immutable classes with `copyWith`, `toString`, equality, etc.
- **JSON Serializable**: `fromJson` and `toJson` methods
- **Flutter Gen**: Type-safe asset access

#### Generate Code

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Or using Melos
melos build:runner
# or: pnpm melos:build:runner

# Or from root
pnpm mobile:build:runner
```

#### Watch Mode (Auto-generate on file changes)

```bash
# Watch for changes and auto-generate
flutter pub run build_runner watch --delete-conflicting-outputs

# Or using Melos
melos watch:runner
# or: pnpm melos:watch:runner

# Or from root
pnpm mobile:watch:runner
```

### Freezed Usage

Create immutable models with code generation:

```dart
// lib/models/receipt.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt.freezed.dart';
part 'receipt.g.dart';

@freezed
class Receipt with _$Receipt {
  const factory Receipt({
    required String id,
    required String userId,
    required String documentHash,
    required DateTime uploadedAt,
    required String aiModel,
    ReceiptData? data,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
}
```

Then run:
```bash
melos build:runner
```

This generates:
- `receipt.freezed.dart` - Immutable class with `copyWith`, equality, etc.
- `receipt.g.dart` - JSON serialization methods

### JSON Serializable Usage

For simple JSON serialization without Freezed:

```dart
// lib/models/receipt_item.dart
import 'package:json_annotation/json_annotation.dart';

part 'receipt_item.g.dart';

@JsonSerializable()
class ReceiptItem {
  final String originalName;
  final String normalizedName;
  final String category;
  final double quantity;
  
  ReceiptItem({
    required this.originalName,
    required this.normalizedName,
    required this.category,
    required this.quantity,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemFromJson(json);
  
  Map<String, dynamic> toJson() => _$ReceiptItemToJson(this);
}
```

### Flutter Gen (Assets)

Generate type-safe asset access:

```bash
# After adding assets to pubspec.yaml, run:
flutter pub run build_runner build

# Then use generated assets:
Assets.images.logo.path
Assets.icons.receipt.path
```

### Flutter Native Splash

Generate native splash screens:

```bash
# Configure in pubspec.yaml, then:
flutter pub run flutter_native_splash:create
```

### Flutter Flavorizr

Configure app flavors (dev/staging/prod):

```bash
# Configure flavors in pubspec.yaml, then:
flutter pub run flutter_flavorizr
```

## BLoC Usage

### Basic BLoC Structure

```dart
// lib/bloc/counter/counter_event.dart
abstract class CounterEvent {}

class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

// lib/bloc/counter/counter_state.dart
class CounterState {
  final int count;
  CounterState(this.count);
}

// lib/bloc/counter/counter_bloc.dart
import 'package:bloc/bloc.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>((event, emit) => emit(CounterState(state.count + 1)));
    on<Decrement>((event, emit) => emit(CounterState(state.count - 1)));
  }
}
```

### Using BLoC in Widgets

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

BlocProvider(
  create: (context) => CounterBloc(),
  child: BlocBuilder<CounterBloc, CounterState>(
    builder: (context, state) {
      return Text('Count: ${state.count}');
    },
  ),
)
```

### Testing BLoC

```dart
import 'package:bloc_test/bloc_test.dart';

blocTest<CounterBloc, CounterState>(
  'emits [1] when Increment is added',
  build: () => CounterBloc(),
  act: (bloc) => bloc.add(Increment()),
  expect: () => [CounterState(1)],
);
```

## Project Structure

```
lib/
  ├── main.dart              # App entry point
  ├── app/                   # App configuration
  │   └── app.dart
  ├── bloc/                  # BLoC state management
  │   ├── counter/
  │   │   ├── counter_bloc.dart
  │   │   ├── counter_event.dart
  │   │   └── counter_state.dart
  │   └── ...
  ├── screens/               # Screen widgets
  │   ├── home/
  │   └── receipts/
  ├── widgets/               # Reusable widgets
  ├── models/                # Data models
  ├── services/              # Business logic and API calls
  ├── repositories/          # Data repositories
  └── utils/                  # Utilities and helpers
```

## Integration with Monorepo

This Flutter app is part of the Smart Receipt monorepo. Integration points:

- **Backend API**: Communicate with `apps/api` for backend services
- **Business Logic**: Reference `@repo/core` for shared business logic
- **Database**: Use `@repo/database` types and schemas via API
- **Shared Types**: Align data models with backend types

### API Communication

```dart
// Example: lib/services/api_service.dart
class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  
  Future<List<Receipt>> getReceipts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/receipts'));
    // Parse and return receipts
  }
}
```

## Environment Variables

Configure environment-specific settings:

```dart
// lib/config/env.dart
class Env {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );
  
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );
}
```

Run with environment variables:

```bash
flutter run --dart-define=API_URL=https://api.example.com
```

## Testing

```bash
# Run unit tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test

# Or using Melos
melos test
```

### Testing BLoC

```bash
# Run BLoC-specific tests
flutter test test/bloc/
```

## Code Style

The project uses `very_good_analysis` for code analysis (enhanced linting rules):

```bash
# Analyze code
flutter analyze

# Or using Melos
melos analyze
```

### Formatting

```bash
# Format code
dart format .

# Or using Melos
melos format
```

## Available Scripts

### From Root (`package.json`)

```bash
# Development
pnpm mobile:dev              # Run on device/emulator

# Builds
pnpm mobile:build:android    # Build Android APK
pnpm mobile:build:ios        # Build iOS

# Code Generation
pnpm mobile:build:runner     # Generate code (one-time)
pnpm mobile:watch:runner     # Watch and generate code

# Testing & Analysis
pnpm mobile:test             # Run tests
pnpm mobile:analyze          # Analyze code

# Melos Commands
pnpm melos:get               # Install dependencies
pnpm melos:analyze           # Analyze with Melos
pnpm melos:test              # Test with Melos
pnpm melos:clean             # Clean with Melos
pnpm melos:format            # Format with Melos
pnpm melos:build:runner      # Generate code with Melos
pnpm melos:watch:runner      # Watch and generate with Melos
pnpm melos:bootstrap         # Bootstrap Melos workspace
```

### Direct Flutter Commands

```bash
cd apps/mobile

flutter pub get                              # Install dependencies
flutter run                                  # Run app
flutter build apk                            # Build Android
flutter build ios                            # Build iOS
flutter test                                 # Run tests
flutter analyze                              # Analyze code
flutter clean                                # Clean build files
flutter pub run build_runner build --delete-conflicting-outputs  # Generate code
flutter pub run build_runner watch --delete-conflicting-outputs  # Watch mode
```

## Dependencies

### Main Dependencies

- `flutter_bloc: ^9.1.1` - BLoC state management
- `bloc: ^9.1.0` - Core BLoC library
- `cupertino_icons: ^1.0.8` - iOS-style icons
- `freezed_annotation: ^3.1.0` - Annotations for Freezed
- `json_annotation: ^4.9.0` - Annotations for JSON serialization

### Dev Dependencies

- `very_good_analysis: ^10.0.0` - Enhanced linting rules (replaces flutter_lints)
- `bloc_test: ^10.0.0` - BLoC testing utilities
- `build_runner: ^2.10.4` - Code generation tool
- `freezed: ^3.2.3` - Code generation for immutable classes
- `json_serializable: ^6.11.2` - JSON serialization code generation
- `flutter_gen_runner: ^5.12.0` - Asset code generation
- `flutter_native_splash: ^2.4.7` - Native splash screen generation
- `flutter_flavorizr: ^2.4.1` - App flavors configuration

## Troubleshooting

### Melos Issues

If Melos commands don't work:

```bash
# Ensure you're in the apps/mobile directory
cd apps/mobile

# Verify melos.yaml exists
ls melos.yaml

# Try bootstrap
melos bootstrap
```

### Flutter Issues

```bash
# Clean and rebuild
flutter clean
flutter pub get

# Check Flutter setup
flutter doctor -v
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter API Reference](https://api.flutter.dev/)
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Melos Documentation](https://melos.invertase.dev/)
- [Flutter BLoC Pattern](https://bloclibrary.dev/#/gettingstarted)
