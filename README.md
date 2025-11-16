# Coinly

A Flutter application built with a simple, pragmatic architecture.

## 🏗️ Architecture

This project follows a **three-layer architecture** for simplicity and maintainability:

```
lib/
├── core/
│   ├── di/                      # Dependency Injection
│   │   └── injection_container.dart
│   ├── errors/                  # Error handling
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                 # Network utilities
│   │   └── network_info.dart
│   ├── theme/                   # App theming
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   └── utils/                  # Utilities & constants
│       └── constants.dart
├── features/                   # Feature modules
│   └── [feature_name]/
│       ├── data/               # 📦 Data Layer
│       │   ├── datasources/    # API & Local storage
│       │   ├── models/         # Data models with JSON
│       │   └── repository/     # Data coordination
│       ├── logic/              # 🧠 Logic Layer
│       │   ├── bloc.dart       # State management
│       │   ├── event.dart      # Events
│       │   └── state.dart      # States
│       └── ui/                 # 🎨 UI Layer
│           ├── pages/          # Screen pages
│           └── widgets/        # Reusable widgets
└── main.dart                   # App entry point
```

## 📦 Key Packages

- **State Management**: `flutter_bloc` - BLoC pattern
- **Dependency Injection**: `get_it` - Service locator
- **Functional Programming**: `dartz` - Either, Option, etc.
- **Value Equality**: `equatable` - Easy value comparison
- **HTTP Client**: `dio` - Network requests
- **Network Info**: `internet_connection_checker` - Connection status
- **Local Storage**: `shared_preferences` - Simple data persistence
- **Fonts**: `google_fonts` - Cairo font family

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.9.2)
- Dart SDK

### Installation

1. Clone the repository
```bash
git clone [your-repo-url]
cd coinly
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 📱 Features

Add your features here as you build them.

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🎨 Architecture Layers

### 1. 📦 Data Layer
**Purpose**: Handle all data operations

**Contains**:
- **Models**: Data classes with JSON serialization
- **Data Sources**: API calls (Remote) and local storage (Local)
- **Repository**: Coordinates between data sources, handles online/offline logic

**Example**:
```dart
// Model
class ExampleModel extends Equatable {
  final String id;
  final String title;
  
  factory ExampleModel.fromJson(Map<String, dynamic> json) { ... }
}

// Repository
class ExampleRepository {
  Future<Either<Failure, List<ExampleModel>>> getExamples() async { ... }
}
```

### 2. 🧠 Logic Layer
**Purpose**: Manage business logic and state

**Contains**:
- **BLoC**: State management with flutter_bloc
- **Events**: User actions/triggers
- **States**: UI states (loading, loaded, error)

**Example**:
```dart
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  final ExampleRepository repository;
  
  // Handle events and emit states
}
```

### 3. 🎨 UI Layer
**Purpose**: Display data and handle user interaction

**Contains**:
- **Pages**: Full-screen views
- **Widgets**: Reusable UI components

**Example**:
```dart
class ExamplePage extends StatelessWidget {
  // BlocProvider + BlocBuilder
  // Display UI based on state
}
```

### Layer Dependencies

```
UI → Logic → Data
```

- UI depends on Logic (BLoC)
- Logic depends on Data (Repository)
- Data is independent (only uses Core)

## 📝 Creating a New Feature

Follow these steps to add a new feature:

### 1. Create Feature Folder Structure
```
lib/features/my_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repository/
├── logic/
└── ui/
    ├── pages/
    └── widgets/
```

### 2. Data Layer

**Model** (`data/models/my_model.dart`):
```dart
class MyModel extends Equatable {
  final String id;
  final String name;
  
  const MyModel({required this.id, required this.name});
  
  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(id: json['id'], name: json['name']);
  }
  
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
  
  @override
  List<Object> get props => [id, name];
}
```

**Data Source** (`data/datasources/my_remote_data_source.dart`):
```dart
class MyRemoteDataSource {
  final Dio dio;
  
  Future<List<MyModel>> fetchData() async {
    final response = await dio.get('/endpoint');
    // Parse and return models
  }
}
```

**Repository** (`data/repository/my_repository.dart`):
```dart
class MyRepository {
  final MyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  Future<Either<Failure, List<MyModel>>> getData() async {
    // Handle online/offline logic
  }
}
```

### 3. Logic Layer

**Events** (`logic/my_event.dart`):
```dart
abstract class MyEvent extends Equatable {}
class LoadDataEvent extends MyEvent {}
```

**States** (`logic/my_state.dart`):
```dart
abstract class MyState extends Equatable {}
class MyInitial extends MyState {}
class MyLoading extends MyState {}
class MyLoaded extends MyState {
  final List<MyModel> data;
}
class MyError extends MyState {
  final String message;
}
```

**BLoC** (`logic/my_bloc.dart`):
```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  final MyRepository repository;
  
  MyBloc({required this.repository}) : super(MyInitial()) {
    on<LoadDataEvent>(_onLoadData);
  }
  
  Future<void> _onLoadData(LoadDataEvent event, Emitter<MyState> emit) async {
    emit(MyLoading());
    final result = await repository.getData();
    result.fold(
      (failure) => emit(MyError(message: failure.message)),
      (data) => emit(MyLoaded(data: data)),
    );
  }
}
```

### 4. UI Layer

**Page** (`ui/pages/my_page.dart`):
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyBloc>()..add(LoadDataEvent()),
      child: Scaffold(
        body: BlocBuilder<MyBloc, MyState>(
          builder: (context, state) {
            if (state is MyLoading) return CircularProgressIndicator();
            if (state is MyLoaded) return MyListWidget(data: state.data);
            if (state is MyError) return Text(state.message);
            return SizedBox();
          },
        ),
      ),
    );
  }
}
```

### 5. Register Dependencies

In `core/di/injection_container.dart`:
```dart
// Logic
sl.registerFactory(() => MyBloc(repository: sl()));

// Data
sl.registerLazySingleton(() => MyRepository(
  remoteDataSource: sl(),
  networkInfo: sl(),
));
sl.registerLazySingleton(() => MyRemoteDataSource(sl()));
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.
