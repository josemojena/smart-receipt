# Smart Receipt Mobile App

Flutter mobile application for Smart Receipt - Expense tracking and receipt management for Android and iOS.

## 🏗️ Architecture

This app follows a **Feature-Based Modular Architecture** using the **BLoC pattern** for state management.

**Key Concepts:**
- ✅ **Features**: Self-contained modules (dashboard, ticket_detail, etc.)
- ✅ **BLoC**: State management for each feature
- ✅ **Shared Code**: Models and widgets used across features
- ✅ **Clean Separation**: UI, business logic, and data are clearly separated

📖 **[See full architecture documentation →](#architecture)**

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

### Freezed Usage for Models

All data models in `lib/shared/models/` use **Freezed** for code generation. This provides:
- ✅ Immutable classes with `copyWith` method
- ✅ Automatic `toString`, `==`, and `hashCode` implementations
- ✅ JSON serialization/deserialization
- ✅ Union types support (optional)

#### Example: Product Model

```dart
// lib/shared/models/product.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String name,
    @JsonKey(name: 'unit_price') required double unitPrice,
    required int quantity,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

// Extension for computed properties
extension ProductExtension on Product {
  double get totalPrice => unitPrice * quantity;
}
```

#### Example: Ticket Model

```dart
// lib/shared/models/ticket.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'product.dart';

part 'ticket.freezed.dart';
part 'ticket.g.dart';

@freezed
class Ticket with _$Ticket {
  const factory Ticket({
    required int id,
    @JsonKey(name: 'store_name') required String storeName,
    required DateTime date,
    @Default(<Product>[]) List<Product> products,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, dynamic> json) =>
      _$TicketFromJson(json);
}

// Extension for computed properties
extension TicketExtension on Ticket {
  double get totalSpent =>
      products.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItems => products.length;
}
```

#### Generating Code

After creating or modifying a model, run:

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Or using Melos
melos build:runner

# Or from root
pnpm mobile:build:runner
```

This generates:
- `*.freezed.dart` - Immutable class with `copyWith`, equality, etc.
- `*.g.dart` - JSON serialization methods (`fromJson`, `toJson`)

#### Using Generated Models

```dart
// Create instances
const product = Product(
  name: 'Leche',
  unitPrice: 1.25,
  quantity: 2,
);

// Use copyWith to create modified copies
final updatedProduct = product.copyWith(quantity: 3);

// JSON serialization
final json = product.toJson();
final fromJson = Product.fromJson(json);

// Use extension methods
final total = product.totalPrice; // 1.25 * 2 = 2.50
```

#### Watch Mode (Auto-generate)

For development, use watch mode to auto-generate on file changes:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs

# Or using Melos
melos watch:runner
```

**Note:** The generated files (`.freezed.dart` and `.g.dart`) should **never** be edited manually. They are automatically generated and will be overwritten.

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

## BLoC Usage (Feature-Based)

### Example: Dashboard Feature BLoC

This example shows the actual structure used in the Dashboard feature:

#### Events (`dashboard_event.dart`)

```dart
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object> get props => [];
}

class DashboardLoadTickets extends DashboardEvent {
  const DashboardLoadTickets();
}

class DashboardScanTicket extends DashboardEvent {
  const DashboardScanTicket();
}
```

#### States (`dashboard_state.dart`)

```dart
import 'package:equatable/equatable.dart';
import '../../../shared/models/models.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<Ticket> tickets;
  final double totalSpent;

  const DashboardLoaded({
    required this.tickets,
    required this.totalSpent,
  });

  @override
  List<Object> get props => [tickets, totalSpent];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object> get props => [message];
}
```

#### BLoC (`dashboard_bloc.dart`)

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial()) {
    on<DashboardLoadTickets>(_onLoadTickets);
    on<DashboardScanTicket>(_onScanTicket);
  }

  Future<void> _onLoadTickets(
    DashboardLoadTickets event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    // Load data...
    emit(DashboardLoaded(tickets: tickets, totalSpent: total));
  }

  Future<void> _onScanTicket(
    DashboardScanTicket event,
    Emitter<DashboardState> emit,
  ) async {
    // Handle scan action
  }
}
```

### Using BLoC in Feature Screens

```dart
// In dashboard_screen.dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(const DashboardLoadTickets()),
      child: Scaffold(
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DashboardError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is DashboardLoaded) {
              return TicketList(tickets: state.tickets);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

### Dispatching Events

```dart
// From UI, dispatch events
context.read<DashboardBloc>().add(const DashboardLoadTickets());

// Or using BlocProvider.of
BlocProvider.of<DashboardBloc>(context).add(const DashboardScanTicket());
```

### Listening to State Changes (Side Effects)

```dart
// Use BlocListener for navigation, snackbars, dialogs, etc.
BlocListener<TicketDetailBloc, TicketDetailState>(
  listener: (context, state) {
    if (state is TicketDetailDeleted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket eliminado.')),
      );
    }
  },
  child: YourWidget(),
)

// Combine BlocListener and BlocBuilder
BlocConsumer<DashboardBloc, DashboardState>(
  listener: (context, state) {
    // Handle side effects
  },
  builder: (context, state) {
    // Build UI
    return YourWidget();
  },
)
```

### Testing BLoC

```dart
import 'package:bloc_test/bloc_test.dart';

blocTest<DashboardBloc, DashboardState>(
  'emits [Loading, Loaded] when LoadTickets is added',
  build: () => DashboardBloc(),
  act: (bloc) => bloc.add(const DashboardLoadTickets()),
  expect: () => [
    const DashboardLoading(),
    isA<DashboardLoaded>(),
  ],
);
```

## Architecture

This app follows a **Feature-Based Modular Architecture** using the **BLoC pattern** for state management. The architecture is designed for scalability, maintainability, and testability.

### Architecture Overview

The app is organized into **features** (modules), where each feature is self-contained with its own:
- **BLoC** (Business Logic Component) for state management
- **UI Screens** and **Widgets**
- **Events** and **States** for the BLoC pattern

Shared code (models, widgets, utilities) is placed in the `shared/` directory.

### Project Structure

```
lib/
├── main.dart                    # App entry point (clean and minimal)
│
├── features/                    # Feature modules (self-contained)
│   ├── dashboard/               # Dashboard/Home feature
│   │   ├── bloc/                # BLoC state management
│   │   │   ├── dashboard_bloc.dart
│   │   │   ├── dashboard_event.dart
│   │   │   └── dashboard_state.dart
│   │   ├── widgets/             # Feature-specific widgets
│   │   │   ├── dashboard_summary_cards.dart
│   │   │   ├── dashboard_scan_button.dart
│   │   │   └── dashboard_ticket_list.dart
│   │   └── dashboard_screen.dart # Main screen
│   │
│   └── ticket_detail/           # Ticket Detail feature
│       ├── bloc/
│       │   ├── ticket_detail_bloc.dart
│       │   ├── ticket_detail_event.dart
│       │   └── ticket_detail_state.dart
│       ├── widgets/
│       │   └── ticket_product_item.dart
│       └── ticket_detail_screen.dart
│
└── shared/                      # Shared code across features
    ├── models/                  # Data models (using Freezed)
    │   ├── product.dart         # Model definition
    │   ├── product.freezed.dart # Generated (immutable class)
    │   ├── product.g.dart      # Generated (JSON serialization)
    │   ├── ticket.dart
    │   ├── ticket.freezed.dart # Generated
    │   ├── ticket.g.dart       # Generated
    │   └── models.dart          # Barrel export
    │
    └── widgets/                  # Reusable widgets
        └── bottom_nav_bar.dart
```

**Note:** Models use **Freezed** for code generation. After modifying models, run `melos build:runner` to regenerate `.freezed.dart` and `.g.dart` files.

### Architecture Principles

#### 1. Feature-Based Organization

Each feature is a **self-contained module** that includes:
- **BLoC**: State management logic
- **Events**: User actions and system events
- **States**: UI state representations
- **Screens**: Main feature screens
- **Widgets**: Feature-specific UI components

**Benefits:**
- ✅ Easy to locate code related to a specific feature
- ✅ Features can be developed independently
- ✅ Easy to add/remove features
- ✅ Clear separation of concerns

#### 2. BLoC Pattern

Each feature uses the **BLoC (Business Logic Component)** pattern:

```
User Action → Event → BLoC → State → UI Update
```

**Components:**
- **Events**: Represent user actions or system events
- **States**: Represent the current state of the feature
- **BLoC**: Processes events and emits new states

**Example Flow:**
```dart
// 1. User taps "Load Tickets" button
// 2. Event is dispatched: DashboardLoadTickets()
// 3. BLoC handles the event
// 4. BLoC emits new state: DashboardLoaded(tickets: [...])
// 5. UI rebuilds with new data
```

#### 3. Shared Code

Code that is used across multiple features is placed in `shared/`:
- **Models**: Data structures (Product, Ticket, etc.)
- **Widgets**: Reusable UI components (BottomNavBar, etc.)
- **Utilities**: Helper functions and constants

### Adding a New Feature

To add a new feature, follow this structure:

1. **Create feature directory:**
   ```bash
   mkdir -p lib/features/my_feature/{bloc,widgets}
   ```

2. **Create BLoC files:**
   ```dart
   // lib/features/my_feature/bloc/my_feature_event.dart
   abstract class MyFeatureEvent extends Equatable {
     const MyFeatureEvent();
     @override
     List<Object> get props => [];
   }
   
   class MyFeatureLoad extends MyFeatureEvent {}
   ```

   ```dart
   // lib/features/my_feature/bloc/my_feature_state.dart
   abstract class MyFeatureState extends Equatable {
     const MyFeatureState();
     @override
     List<Object> get props => [];
   }
   
   class MyFeatureInitial extends MyFeatureState {}
   class MyFeatureLoaded extends MyFeatureState {
     final List<Data> items;
     const MyFeatureLoaded(this.items);
     @override
     List<Object> get props => [items];
   }
   ```

   ```dart
   // lib/features/my_feature/bloc/my_feature_bloc.dart
   class MyFeatureBloc extends Bloc<MyFeatureEvent, MyFeatureState> {
     MyFeatureBloc() : super(MyFeatureInitial()) {
       on<MyFeatureLoad>(_onLoad);
     }
     
     Future<void> _onLoad(
       MyFeatureLoad event,
       Emitter<MyFeatureState> emit,
     ) async {
       emit(MyFeatureLoading());
       // Load data...
       emit(MyFeatureLoaded(data));
     }
   }
   ```

3. **Create widgets (if needed):**
   ```dart
   // lib/features/my_feature/widgets/my_feature_item.dart
   class MyFeatureItem extends StatelessWidget {
     // Widget implementation
   }
   ```

4. **Create screen:**
   ```dart
   // lib/features/my_feature/my_feature_screen.dart
   class MyFeatureScreen extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return BlocProvider(
         create: (context) => MyFeatureBloc()..add(MyFeatureLoad()),
         child: Scaffold(
           // UI implementation
         ),
       );
     }
   }
   ```

### BLoC Usage Examples

#### Using BLoC in a Screen

```dart
// Wrap screen with BlocProvider
BlocProvider(
  create: (context) => DashboardBloc()..add(DashboardLoadTickets()),
  child: DashboardScreen(),
)

// In the screen, use BlocBuilder to react to state changes
BlocBuilder<DashboardBloc, DashboardState>(
  builder: (context, state) {
    if (state is DashboardLoading) {
      return CircularProgressIndicator();
    }
    if (state is DashboardLoaded) {
      return TicketList(tickets: state.tickets);
    }
    return SizedBox.shrink();
  },
)
```

#### Dispatching Events

```dart
// Dispatch an event from UI
context.read<DashboardBloc>().add(DashboardScanTicket());

// Or use BlocProvider.of(context)
BlocProvider.of<DashboardBloc>(context).add(DashboardScanTicket());
```

#### Listening to State Changes

```dart
// Use BlocListener for side effects (navigation, snackbars, etc.)
BlocListener<TicketDetailBloc, TicketDetailState>(
  listener: (context, state) {
    if (state is TicketDetailDeleted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket deleted')),
      );
    }
  },
  child: YourWidget(),
)
```

### Code Organization Guidelines

1. **One feature per directory**: Each feature has its own directory
2. **BLoC in every feature**: Each feature manages its own state
3. **Widgets close to usage**: Feature-specific widgets stay in the feature
4. **Shared code in `shared/`**: Only truly shared code goes here
5. **Barrel exports**: Use `models.dart` to export all models
6. **Clean main.dart**: Keep `main.dart` minimal (only app setup)

### Benefits of This Architecture

✅ **Scalability**: Easy to add new features without affecting existing ones  
✅ **Maintainability**: Clear structure makes code easy to find and modify  
✅ **Testability**: BLoC pattern makes unit testing straightforward  
✅ **Team Collaboration**: Multiple developers can work on different features  
✅ **Code Reusability**: Shared components are easily accessible  
✅ **Separation of Concerns**: UI, business logic, and data are clearly separated

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
